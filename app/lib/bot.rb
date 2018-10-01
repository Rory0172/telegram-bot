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
        chat_member = @bot.api.get_chat_member(chat_id:ENV["CHATID"], user_id: message.from.id)
        chat = @bot.api.get_chat(chat_id:ENV["CHATID"])
        puts chat_member
        chat_title = chat["result"]["title"]
        if chat_member["result"]["status"] != "left" and chat_member["result"]["status"] != "kicked"
          case message
          when Telegram::Bot::Types::CallbackQuery
            self.callback(message)
          when Telegram::Bot::Types::Message
            @user = User.find_by(telegram_id: message.from.id)
            if @user
              text = message.text
              self.message(message, text)
            else
              User.create(telegram_id: message.from.id, username: message.from.username, chat_id:message.from.id)
              reply ({chat_id: message.from.id, text:"Welcome to the *DCT* bot!\nThis bot will help you organize crypto signals and alert you when targets are hit. This bot can listen to your commands:\n\n*Help*\nNot sure how to get started? Just type /help\n\n*Signals*\nGet an overview of our current signals using /signals\n\n*Coinname*\nGet the status on an active signal by using the right abbreviation of a coin. _For example: /btc_", parse_mode:"markdown"})
            end
          end
        else
          reply ({chat_id: message.from.id, text:"You are not a member of the premium group *#{chat_title}*. If you would like to access this bot, please contact @admin.", parse_mode:"markdown"})
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
    begin
      @bot.api.send_message msg
    rescue Exception => e
      Rails.logger.info e
    end
  end
end

