require 'telegram/bot'
class Bot
  def initialize(token)
    @token=token
  end
  def start_listening
    Telegram::Bot::Client.run(@token) do |bot|
      @bot = bot
      @bot.listen do |message|
       # if @bot.api.get_chat_member(chat_id:, user_id: message.from.id)
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

