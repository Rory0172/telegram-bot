class CoinBot < Bot
  def message(msg)
    if msg.text.match /TARGETS/i
      Coin.all.each do |coin|
        @signal = coin.coin_signals.last
        if !@signal.blank?
          reply({chat_id: msg.chat.id, text:"*#{coin.name}* (#{@signal.exchange}): #{@signal.result} #{@signal.result.to_f < 0 ? "\u{2B07}" : "\u{2B06}"}", parse_mode:"markdown"})
        end
      end
    end

    if msg.text.match /\b[A-Z]{3}\b/i
      @coin = Coin.find_by(name: msg.text)
      if @coin.blank?
        reply ({chat_id: msg.chat.id, text:"There are no signals given or this coin is not added yet."})
      else
        btc = Binance::Api.ticker!(symbol: "BTCUSDT", type: "price")
        if msg.text == "BTC"
          @coin.current_price = btc[:price]
        else
          current_states_coin = Binance::Api.ticker!(symbol: "#{msg.text}BTC", type: "price")
          price_btc = btc[:price].to_f
          @coin.current_price = current_states_coin[:price].to_f * price_btc
          @coin.save
        end
        @signal = @coin.coin_signals.last
        if @signal.blank?
          reply ({chat_id: msg.chat.id, text:"No signals given yet!"})
        else
          reply({chat_id: msg.chat.id, text:"*Target #{@coin.name} (#{@signal.exchange})*\n#{@signal.time_ago} ago\nCurrent price: #{@coin.current_price}\nResult: #{@signal.result} #{@signal.result.to_f < 0 ? "\u{2B07}" : "\u{2B06}"}\nEntry: #{@signal.entry_price}\nTarget 1: #{@signal.sell_target_1}\nTarget 2: #{@signal.sell_target_2}\nStoploss: #{@signal.stoploss}", parse_mode:"markdown"})
        end
      end
    end
  end

  def announce(signal)
    @coin = Coin.find(signal.coin.id)
    Telegram::Bot::Client.run(@token) do |bot|
      User.all.each do |user|
        bot.api.send_message(chat_id: user.chat_id, text:"*New Target #{@coin.name} (#{signal.exchange})*\nCurrent price: #{@coin.current_price}\nResult: #{signal.result}\nEntry: #{signal.entry_price}\nTarget 1: #{signal.sell_target_1}\nTarget 2: #{signal.sell_target_2}\nStoploss: #{signal.stoploss}", parse_mode:"markdown")
      end
    end
  end

  private

end
