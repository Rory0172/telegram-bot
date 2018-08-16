class CoinSignal < ApplicationRecord
  belongs_to :coin

  def result
    "#{coin.current_price / entry_price * 100 - 100}%"
  end

  after_create :announce
  def announce
    CoinBot.new(ENV["BOTTOKEN"]).announce(self)
  end
end
