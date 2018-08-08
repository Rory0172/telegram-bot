class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users, force: true do |t|
      t.string :telegram_id
      t.string :username
      t.timestamps null: false
    end
  end
end
