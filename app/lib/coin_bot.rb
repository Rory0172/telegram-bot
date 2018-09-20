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

  def callback(msg)
    if msg.data == 'signal'
      kb = []
      CoinSignal.all.each do |signal|
        kb = kb.push(Telegram::Bot::Types::InlineKeyboardButton.new(text: signal.coin.name, callback_data: 'signal'))
      end
      markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
      reply({chat_id: msg.from.id, text:"signals:", reply_markup: markup})
    end
    if msg.data == 'signals'
      text = msg.data
      self.message(msg, text)
    end
  end

  def message(msg, text)
    if text.match /signals/i
      if CoinSignal.all.blank?
        reply({chat_id: msg.from.id, text:"There are no signals given yet."})
      else
        text = "Click on a signal to get detailed information or use */coinname*.\n\n*Active signals:*\n"
        CoinSignal.all.each{|signal| text << "/#{signal.coin.name} (#{signal.exchange}): #{signal.result} #{signal.result.to_f < 0 ? "\u{2B07}" : "\u{2B06}"}\n"}
        reply({chat_id: msg.from.id, text: text, parse_mode:"markdown"})
      end
    end

    if text.match /^\/\b[A-Za-z]{3}\b$/i
      @coin = Coin.find_by(name: text[1..3].upcase)
      if @coin.blank?
        reply ({chat_id: msg.from.id, text:"Can’t find this specific coin. Make sure that you use the correct abbreviation or check /signals for active signals.  "})
      else
        self.set_price(text[1..3].upcase)
        @signal = @coin.coin_signals.last
        if @signal.blank?
          reply ({chat_id: msg.from.id, text:"There is no signal given for *#{text[1..3].upcase}*. Please use /signals to get an overview for active signals.", parse_mode:"markdown"})
        else
          reply({chat_id: msg.from.id, text:"*Target #{@coin.name} (#{@signal.exchange})*\n#{@signal.time_ago} ago\nCurrent price: #{@coin.current_price}\nResult: #{@signal.result} #{@signal.result.to_f < 0 ? "\u{2B07}" : "\u{2B06}"}\nEntry: #{@signal.entry_price}\nTarget 1: #{@signal.sell_target_1}\nTarget 2: #{@signal.sell_target_2}\nStoploss: #{@signal.stoploss}#{"\nNote: #{@signal.note}" unless @signal.note.blank?}", parse_mode:"markdown"})
        end
      end
    end
    if text.match /help/i
      kb = [
        Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Get signal for a coin', callback_data: 'signal'),
        Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Get signal overview', callback_data: 'signals')
      ]
      markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
      reply({chat_id: msg.chat.id, text: 'This bot will help you organize crypto signals and alert you when targets are hit. How can I help you?', reply_markup: markup})
    end
  end

  def announce(signal)
    self.set_price(signal.coin.name)
    Telegram::Bot::Client.run(@token) do |bot|
      User.all.each do |user|
        bot.api.send_message(chat_id: user.chat_id, text:"\u{26A1} *NEW SIGNAL* \u{26A1}\n\n*#{@coin.name} (#{signal.exchange})*\nEntry: #{signal.entry_price}\nCurrent price: #{@coin.current_price}\n\nTarget 1: #{signal.sell_target_1}\nTarget 2: #{signal.sell_target_2}\nStoploss: #{signal.stoploss}#{"\n\nNote: #{signal.note}" unless signal.note.blank?}", parse_mode:"markdown")
      end
    end
  end

  private

end
