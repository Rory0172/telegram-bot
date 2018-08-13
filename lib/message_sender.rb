# require './lib/reply_markup_formatter'
# require './lib/app_configurator'

# class MessageSender
#   attr_reader :bot
#   attr_reader :text
#   attr_reader :chat
#   attr_reader :answers
#   attr_reader :logger

#   def initialize(options)
#     @bot  = options[:bot]
#     @text = options[:text]
#     @chat = options[:chat]
#     @answers = options[:answers]
#     @logger = Rails.logger
#   end

#   def send
#     bot.api.send_message(chat_id: chat.id, text: text)
#     logger.debug "sending '#{text}' to #{chat.username}"
#   end
# end