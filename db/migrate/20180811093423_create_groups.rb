class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.belongs_to :admin_user, foreign_key: true, null: false
      t.string :name, null: false
      t.integer :chat_id, null: false

      t.timestamps
    end
  end
end
