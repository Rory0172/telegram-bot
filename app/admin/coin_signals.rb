ActiveAdmin.register CoinSignal do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
 permit_params :coin_id, :exchange, :entry_price_low, :entry_price_high, :sell_target_1_low, :sell_target_1_high, :sell_target_2_low, :sell_target_2_high, :stoploss, :note


  form do |f|
    f.inputs do
      f.input :coin, as: :select, label: "Abbreviation coin"
      f.input :exchange
      f.input :entry_price_low
      f.input :entry_price_high
      f.input :sell_target_1_low
      f.input :sell_target_1_high
      f.input :sell_target_2_low
      f.input :sell_target_2_high
      f.input :stoploss
      f.input :note, as: :text
    end
  f.actions
  end
end
