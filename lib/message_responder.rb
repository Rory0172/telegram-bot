require File.expand_path('../../config/environment',  __FILE__)
require './lib/message_sender'

class MessageResponder
  attr_reader :message
  attr_reader :bot
  attr_reader :user

  def initialize(options)
    @bot = options[:bot]
    @message = options[:message]
    @user = User.find_or_create_by(telegram_id: message.from.id, username: message.from.username)
  end

  def respond
    on /^\/start/ do
      answer_with_greeting_message
    end

    on /^\/stop/ do
      answer_with_farewell_message
    end
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
    answer_with_message "Hi @#{@user.username}, how are you?"
  end

  def answer_with_farewell_message
    answer_with_message 'farewell_message'
  end

  def answer_with_message(text)
    MessageSender.new(bot: bot, chat: message.chat, text: text).send
  end
end