require 'telegram/bot'
class Bot
  def initialize(token)
    @token=token
  end
  def start_listening
    Telegram::Bot::Client.run(@token) do |bot|
      @bot = bot
      @bot.listen do |message|
        Rails.logger.info message
        chat_member = @bot.api.get_chat_member(chat_id:"-233641844", user_id: message.from.id)
        if chat_member["result"]["status"] != "left" and chat_member["result"]["status"] != "kicked"
          case message
          when Telegram::Bot::Types::CallbackQuery
            self.callback(message)
          when Telegram::Bot::Types::Message
            @user = User.find_or_create_by(telegram_id: message.from.id, username: message.from.username, chat_id:message.from.id)
            text = message.text
            self.message(message, text)
          end
        end
      end
    end
  end

  def current_user
    @user
  end

  def callback(msg)
  end

  def message(msg)
  end

  def announce(signal)
  end

  def reply(msg)
    @bot.api.send_message msg
  end
end

