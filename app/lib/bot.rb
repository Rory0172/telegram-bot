class Bot
  def initialize(token)
    @token=token
  end

  def start
    Telegram::Bot::Client.run(@token) do |bot|
      @bot = bot
      @bot.listen do |message|
        @user = User.find_or_create_by(telegram_id: message.from.id, username: message.from.username, chat_id:message.chat.id)
        self.message(message)
      end
    end
  end

  def current_user
    @user
  end

  def message(msg)
  end

  def reply(msg)
    @bot.api.send_message msg
  end
end

