require './lib/send_new_signal_to_users'
ActiveAdmin.register CoinSignal do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
 permit_params :coin_id, :exchange, :entry_price, :sell_target_1, :sell_target_2, :stoploss
#

  form do |f|
    f.inputs do
      f.input :coin
      f.input :exchange
      f.input :entry_price
      f.input :sell_target_1
      f.input :sell_target_2
      f.input :stoploss
    end
  f.submit
  end

  after_create do |signal|
    SendNewSignalToUsers.new(signal: signal).create
  end
end
