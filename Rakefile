# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

task bot: :environment do
  require 'telegram/bot'

  token = YAML::load(IO.read('config/secrets.yml'))['telegram_bot_token']
  bot   = CoinBot.new(token)
  bot.start
end

task binance: :environment do
  config = AppConfigurator.new
  logger = config.get_logger

  coins = ["ETH", "XRP", "BCC", "EOS"]
  data = []

  coins.each do |coin|
    data.push(Binance::Api.ticker!(symbol: "#{coin}BTC", type: "price"))
  end

  btc = Binance::Api.ticker!(symbol: "BTCUSDT", type: "price")
  btc = btc[:price].to_f

  data.each{ |coin|
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