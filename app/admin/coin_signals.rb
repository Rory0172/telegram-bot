ActiveAdmin.register CoinSignal do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
 permit_params :coin_id, :exchange, :entry_price, :sell_target_1, :sell_target_2, :stoploss, :note
#

  form do |f|
    f.inputs do
      f.input :coin, as: :select, label: "Abbreviation coin"
      f.input :exchange
      f.input :entry_price
      f.input :sell_target_1
      f.input :sell_target_2
      f.input :stoploss
      f.input :note, as: :text
    end
  f.actions
  end
end
