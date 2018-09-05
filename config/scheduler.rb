require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.every '5m' do
  system "rake binance"
end

scheduler.join
  # let the current thread join the scheduler thread