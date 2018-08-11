class CreateCoinSignals < ActiveRecord::Migration[5.2]
  def change
    create_table :coin_signals do |t|
      t.belongs_to :coin, foreign_key: true, null: false
      t.string :exchange, default: 'Binance'
      t.float :entry_price, null: false
      t.float :sell_target_1, null: false
      t.float :sell_target_2
      t.float :stoploss, null: false
      t.timestamps
    end
  end
end
