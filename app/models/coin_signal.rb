class CoinSignal < ApplicationRecord
  belongs_to :coin

  def result
    "#{(coin.current_price / entry_price_low  * 100 - 100).round(1)}%"
  end

  after_create :announce
  def announce
    CoinBot.new(ENV["BOTTOKEN"]).announce(self)
  end

  def time_ago
    diff_seconds = Time.now - created_at
    case diff_seconds
      when 0 .. 59
        "#{diff_seconds.round} seconds"
      when 60 .. (3600-1)
        "#{(diff_seconds/60).round} minutes"
      when 3600 .. (3600*24-1)
        "#{(diff_seconds/3600).round} hours"
      when (3600*24) .. (3600*24*30) 
        "#{(diff_seconds/(3600*24)).round} days"
      else
        start_time.strftime("%m/%d/%Y")
    end
  end
end
