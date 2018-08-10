# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

Binance::Api::Configuration.api_key = "lelGeXpZ7SB2uPKC7aPvSGYGw7qq9l9pknzxuIc1Dg1nQkfXbMLAO2RevD6jQdJI"
Binance::Api::Configuration.secret_key = nil
