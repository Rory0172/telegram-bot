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

    if msg.text.match /kanniet/i
      reply({chat_id: msg.chat.id, text: ["white supremancy","burn","kkk"].sample})
    end

    if msg.text.match /bier/i
      reply({chat_id: msg.chat.id, text: "zelf acolist he!  #{current_user.username}! "})
    end

    if msg.text.match /show (.*)/i
      x = User.find_by_username($1)
      reply({chat_id: msg.chat.id, text: "zelf acolist he! #{x.id}"})
    end

    if msg.text.match /users/i
      reply({chat_id: msg.chat.id, text: User.pluck(:username).join(",")})
    end
  end

  def send_to_all(signal)
    @coin = Coin.find(signal.coin)
    @signal = @coin.coin_signals.last
    User.all.each do |user|
      reply({chat_id: user.chat_id, text:"Target #{@coin.name} (#{@signal.exchange})\nCurrent price: #{@coin.current_price}\nResult: #{@signal.result}\nEntry: #{@signal.entry_price}\nTarget 1: #{@signal.sell_target_1}\nTarget 2:#{@signal.sell_target_2}\nStoploss: #{@signal.stoploss}"})
    end
  end

  private

end
