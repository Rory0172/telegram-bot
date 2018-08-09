class CreateCoinSignals < ActiveRecord::Migration[5.2]
  def change
    create_table :coin_signals do |t|
      t.belongs_to :coin, foreign_key: true, null: false
      t.string :exchange
      t.decimal :entry_price, null: false
      t.decimal :sell_target_1, null: false
      t.decimal :sell_target_2
      t.decimal :stoploss, null: false
      t.timestamps
    end
  end
end
