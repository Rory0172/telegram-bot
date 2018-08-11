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
  btc = btc[:price].to_f

  logger.debug coins
  coins.each{ |coin|
    price = (coin[:price].to_f * btc)
    name = coin[:symbol][0..2]
    logger.debug coin[:price]
    db_coin = Coin.find_or_create_by!(name: name)
    db_coin[:current_price] = price
    db_coin.save
   }

  coin = Coin.find_or_create_by name: "BTC"
  coin[:current_price] = btc
  coin.save
end