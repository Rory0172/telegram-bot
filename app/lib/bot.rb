require 'telegram/bot'
class Bot
  def initialize(token)
    @token=token
  end
  def start_listening
    Telegram::Bot::Client.run(@token) do |bot|
      @bot = bot
      @bot.listen do |message|
        @user = User.find_or_create_by(telegram_id: message.from.id, username: message.from.username, chat_id:message.from.id)
        case message
       # if @bot.api.get_chat_member(chat_id:, user_id: message.from.id)
        when Telegram::Bot::Types::CallbackQuery
          if message.data == 'signals'
            self.message(message)
          end
          if message.data == 'signal'
            reply(chat_id: message.from.id, text: "text")
          end
        when Telegram::Bot::Types::Message
          self.message(message)
        end
        #@user = User.find_or_create_by(telegram_id: message.from.id, username: message.from.username, chat_id:message.chat.id)
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

