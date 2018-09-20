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
    Rails.logger = Logger.new(STDOUT)
    Rails.logger.info coin
    price = 0
    name = coin[:symbol][0..2]
    db_coin = Coin.find_or_create_by!(name: name)
    db_coin[:symbol] = coin[:symbol]
    db_coin[:current_price] = price
    db_coin.save
  end
end

task binance: :environment do
  require 'telegram/bot'
  Telegram::Bot::Client.run(ENV["BOTTOKEN"]) do |bot|
    CoinSignal.all.each do |signal|
      timeDifference = DateTime.now.strftime('%Q').to_i - signal.created_at.to_datetime.strftime('%Q').to_i
      time = timeDifference - 600000
      data = Binance::Api.candlesticks!(symbol:signal.coin.symbol, startTime: signal.created_at.to_datetime.strftime('%Q').to_i + time, endTime:DateTime.now.strftime('%Q'), interval: "5m")
      Rails.logger = Logger.new(STDOUT)
      Rails.logger.info data
      data.each do |coin|
        if !signal.target_1_completed and signal.sell_target_1_low < coin[2].to_f
          Rails.logger.info "signal 1 hit"
          User.all.each do |user|
            bot.api.send_message(chat_id: user.chat_id, text: "\u{1F3AF} *Update #{signal.coin.name}*\nTarget of *#{signal.sell_target_1_low}* is hit! That's allready #{(signal.sell_target_1_low / signal.entry_price_low * 100 - 100).round}% profit in #{signal.time_ago}! Next target up is #{signal.sell_target_2_low}!", parse_mode:"markdown")
          end
          signal.target_1_completed = true
          signal.save
        end
        if !signal.target_2_completed and signal.sell_target_2_low < coin[2].to_f
          Rails.logger.info "signal 2 hit"
          User.all.each do |user|
            bot.api.send_message(chat_id: user.chat_id, text: "\u{1F3AF} *Update #{signal.coin.name}*\nTarget of *#{signal.sell_target_2_low}* is hit! That's another #{(signal.sell_target_1_low / signal.entry_price_low * 100 - 100).round}% profit in #{signal.time_ago}!", parse_mode:"markdown")
          end
          signal.target_2_completed = true
          signal.save
        end
        if !signal.stoploss_completed and signal.stoploss > coin[3].to_f
          Rails.logger.info "stoploss hit"
          User.all.each do |user|
            bot.api.send_message(chat_id: user.chat_id, text: "\u{26A0} *Update #{signal.coin.name}*\nStoploss of *#{signal.stoploss}* is hit!", parse_mode:"markdown")
          end
          signal.stoploss_completed = true
          signal.save
        end
      end
    end
  end
end