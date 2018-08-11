class Group < ApplicationRecord
  has_many :coin_signals
  has_many :users
end
