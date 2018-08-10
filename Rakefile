# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

require './lib/app_configurator'

task binance: :environment do
  config = AppConfigurator.new
  logger = config.get_logger

  coins = []
  btc = Binance::Api.ticker!(symbol: "BTCUSDT", type: "price")
  ethbtc = Binance::Api.ticker!(symbol: "ETHBTC", type: "price")
  coins.push(ethbtc)
  xrpbtc = Binance::Api.ticker!(symbol: "XRPBTC", type: "price")
  coins.push(xrpbtc)
  bccbtc = Binance::Api.ticker!(symbol: "BCCBTC", type: "price")
  coins.push(bccbtc)
  eosbtc = Binance::Api.ticker!(symbol: "EOSBTC", type: "price")
  coins.push(eosbtc)
  btc = btc[:price]

  logger.debug coins
  coins.each{ |coin|
    price = coin[:price] * btc
    name = coin[:symbol][0..2]
    logger.debug name
    coin = Coin.find_or_create_by!(name: name)
    coin[:current_price] = price
    coin.save
   }

  coin = Coin.find_or_create_by name: "BTC"
  coin[:current_price] = btc
  coin.save
end