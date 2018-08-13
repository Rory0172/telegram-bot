#!/usr/bin/env ruby
require 'telegram/bot'
require './lib/app_configurator'

class SendMewSignalToUsers
  attr_reader :message
  attr_reader :bot
  attr_reader :user

  def initialize(signal)
    config = AppConfigurator.new
    @token = config.get_token
    @logger = config.get_logger
    @coin = Coin.find(signal[:coin_id])
    @signal = @coin.coin_signals.last
    @users = Users.all
  end

  def create
    logger.debug 'Start sending signals'
    text = "Target #{@coin.name} (#{@signal.exchange})\nCurrent price: #{@coin.current_price}\nResult: #{@signal.result}\nEntry: #{@signal.entry_price}\nTarget 1: #{@signal.sell_target_1}\nTarget 2:#{@signal.sell_target_2}\nStoploss: #{@signal.stoploss}"
    Telegram::Bot::Client.run(token) do |bot|
      users.each do |user|
        chat_id = user.chat_id
        MessageSender.new(bot: bot, chat: chat_id, text: text).send
      end
    end
  end
end
