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
    bot.api.send_message(chat_id: "546865437", text: "MNever")
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

  coins = ["ETH", "XRP", "BCC", "EOS"]
  data = []

  coins.each do |coin|
    data.push(Binance::Api.ticker!(symbol: "#{coin}BTC", type: "price"))
  end

  btc = Binance::Api.ticker!(symbol: "BTCUSDT", type: "price")
  btc = btc[:price].to_f

  data.each do |coin|
    price = (coin[:price].to_f * btc)
    name = coin[:symbol][0..2]
    Rails.logger.info price
    db_coin = Coin.find_or_create_by!(name: name)
    db_coin[:current_price] = price
    db_coin.save
  end

  coin = Coin.find_or_create_by name: "BTC"
  coin[:current_price] = btc
  coin.save
end