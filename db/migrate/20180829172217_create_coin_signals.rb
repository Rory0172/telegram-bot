class CreateCoinSignals < ActiveRecord::Migration[5.2]
  def change
    create_table :coin_signals do |t|
      t.belongs_to :coin, foreign_key: true,  null: false
      t.string :exchange, default: 'Binance'
      t.float :entry_price_low,               null: false
      t.float :entry_price_high,              null: false
      t.float :sell_target_1_low,             null: false
      t.float :sell_target_1_high,            null: false
      t.float :sell_target_2_low
      t.float :sell_target_2_high
      t.float :stoploss,                      null: false
      t.string :note
      t.boolean :target_1_completed, default: false
      t.boolean :target_2_completed, default: false
      t.boolean :stoploss_completed, default: false
      t.timestamps
    end
  end
end
