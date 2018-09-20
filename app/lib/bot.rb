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
          if message.data == 'signal'
            kb = []
            CoinSignal.all.each do |signal|
              kb = kb.push(Telegram::Bot::Types::InlineKeyboardButton.new(text: signal.coin.name, callback_data: 'signal'))
            end
            markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
            reply({chat_id: message.from.id, text:"signals:", reply_markup: markup})
          end
          if message.data == 'signals'
            text = message.data
            self.message(message, text)
          end
        when Telegram::Bot::Types::Message
          text = message.text
          self.message(message, text)
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

