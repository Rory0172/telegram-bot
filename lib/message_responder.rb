require File.expand_path('../../config/environment',  __FILE__)
require './lib/message_sender'
require './lib/app_configurator'

class MessageResponder
  attr_reader :message
  attr_reader :bot
  attr_reader :user

  def initialize(options)
    @bot = options[:bot]
    @message = options[:message]
    @user = User.find_or_create_by(telegram_id: message.from.id, username: message.from.username, group_id: 1)
    @coin = Coin.find_by(name: message.text[1..3])
    @signal = @coin.coin_signals.last
  end

  def respond
    answer_coin_signal
  end

  private

  def on regex, &block
    regex =~ message.text

    if $~
      case block.arity
      when 0
        yield
      when 1
        yield $1
      when 2
        yield $1, $2
      end
    end
  end

  def answer_with_greeting_message
    answer_with_message "Hi #{@user.username}, how are you?"
  end

  def answer_with_farewell_message
    answer_with_message 'farewell_message'
  end

  def answer_coin_signal
    if @signal.blank?
      answer_with_message "No signals given yet!"
    else
      answer_with_message "Target #{@coin.name} (#{@signal.exchange})\nCurrent price: #{@coin.current_price}\nResult: #{@signal.result}\nEntry: #{@signal.entry_price}\nTarget 1: #{@signal.sell_target_1}\nTarget 2:#{@signal.sell_target_2}\nStoploss: #{@signal.stoploss}"
    end
  end

  def answer_with_message(text)
    MessageSender.new(bot: bot, chat: message.chat, text: text).send
  end
end