class CoinBot < Bot
  def message(msg)
    @coin = Coin.find_by(name: msg.text)
    if @coin.blank?
      reply ({chat_id: msg.chat.id, text:"Coin is not added yet."})
    else
      @signal = @coin.coin_signals.last
      if @signal.blank?
        reply ({chat_id: msg.chat.id, text:"No signals given yet!"})
      else
        reply({chat_id: msg.chat.id, text:"Target #{@coin.name} (#{@signal.exchange})\nCurrent price: #{@coin.current_price}\nResult: #{@signal.result}\nEntry: #{@signal.entry_price}\nTarget 1: #{@signal.sell_target_1}\nTarget 2:#{@signal.sell_target_2}\nStoploss: #{@signal.stoploss}"})
      end
    end
  end

  def announce(signal)
    @coin = Coin.find(signal.coin.id)
    Telegram::Bot::Client.run(@token) do |bot|
      User.all.each do |user|
        bot.api.send_message(chat_id: user.chat_id, text:"*New Target #{@coin.name} (#{signal.exchange})*\nCurrent price: #{@coin.current_price}\nResult: #{signal.result}\nEntry: #{signal.entry_price}\nTarget 1: #{signal.sell_target_1}\nTarget 2:#{signal.sell_target_2}\nStoploss: #{signal.stoploss}", parse_mode:"markdown")
      end
    end
  end

  private

end
