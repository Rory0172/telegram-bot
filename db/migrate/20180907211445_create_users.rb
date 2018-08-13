class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users, force: true do |t|
      t.string :telegram_id, null: false
      t.string :username, null: false
      t.integer :chat_id, null: false
      t.timestamps null: false
    end
  end
end
