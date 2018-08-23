# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

task bot: :environment do
  require 'telegram/bot'

  bot   = CoinBot.new(ENV["BOTTOKEN"])
  bot.start_listening
end

task send: :environment do
  require 'telegram/bot'
  Telegram::Bot::Client.run(ENV["BOTTOKEN"]) do |bot|
    bot.api.send_message(chat_id: "546865437", text: "MNever \u{1F601}")
  end
end


task coins: :environment do
  data = Binance::Api.ticker!(type: "price")
  data.each do |coin|
    price = 0
    name = coin[:symbol][0..2]
    Rails.logger.info name
    db_coin = Coin.find_or_create_by!(name: name)
    db_coin[:current_price] = price
    db_coin.save
  end
end

task binance: :environment do
  data = Binance::Api.candlesticks!(symbol: "BTCUSDT", interval: "15m", limit: 1)
  Rails.logger = Logger.new(STDOUT)
  Rails.logger.info data
end