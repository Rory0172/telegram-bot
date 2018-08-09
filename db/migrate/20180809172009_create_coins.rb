class CreateCoins < ActiveRecord::Migration[5.2]
  def change
    create_table :coins do |t|
      t.string :name, null: false
      t.decimal :current_price

      t.timestamps
    end
  end
end
