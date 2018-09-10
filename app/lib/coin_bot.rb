class CoinBot < Bot

  def set_price(coin_name)
    @coin = Coin.find_by(name: coin_name)
    btc = Binance::Api.ticker!(symbol: "BTCUSDT", type: "price")
    if coin_name == "BTC"
      @coin.current_price = btc[:price]
      @coin.save
    else
      binance_data_coin = Binance::Api.ticker!(symbol: "#{coin_name}BTC", type: "price")
      price_btc = btc[:price].to_f
      @coin.current_price = binance_data_coin[:price].to_f * price_btc
      @coin.save
    end
  end

  def message(msg)
    if msg.text.match /TARGETS/i
      if CoinSignal.all.blank?
        reply({chat_id: msg.chat.id, text:"There are no signals given yet."})
      else
        text = "Click on a signal to get detailed information or use */coinname*.\n\nActive signals:\n"
        CoinSignal.all.each{|signal| text << "/#{signal.coin.name} (#{signal.exchange}): #{signal.result} #{signal.result.to_f < 0 ? "\u{2B07}" : "\u{2B06}"}\n"}
        reply({chat_id: msg.chat.id, text: text, parse_mode:"markdown"})
      end
    end

    if msg.text.match /\/\b[A-Z]{3}\b/i
      @coin = Coin.find_by(name: msg.text[1..3])
      if @coin.blank?
        reply ({chat_id: msg.chat.id, text:"Can't find this specific coin. Make sure that you use the correct abbreviation."})
      else
        self.set_price(msg.text[1..3])
        @signal = @coin.coin_signals.last
        if @signal.blank?
          reply ({chat_id: msg.chat.id, text:"There is no signal given for #{msg.text[1..3]}. Please use /targets to get an overview for active targets."})
        else
          reply({chat_id: msg.chat.id, text:"*Target #{@coin.name} (#{@signal.exchange})*\n#{@signal.time_ago} ago\nCurrent price: #{@coin.current_price}\nResult: #{@signal.result} #{@signal.result.to_f < 0 ? "\u{2B07}" : "\u{2B06}"}\nEntry: #{@signal.entry_price}\nTarget 1: #{@signal.sell_target_1}\nTarget 2: #{@signal.sell_target_2}\nStoploss: #{@signal.stoploss}", parse_mode:"markdown"})
        end
      end
    end
  end

  def announce(signal)
    self.set_price(signal.coin.name)
    Telegram::Bot::Client.run(@token) do |bot|
      User.all.each do |user|
        bot.api.send_message(chat_id: user.chat_id, text:"\u{26A1} *NEW TARGET* \u{26A1}\n\n*#{@coin.name} (#{signal.exchange})*\nEntry: #{signal.entry_price}\nCurrent price: #{@coin.current_price}\n\nTarget 1: #{signal.sell_target_1}\nTarget 2: #{signal.sell_target_2}\nStoploss: #{signal.stoploss}", parse_mode:"markdown")
      end
    end
  end

  private

end
