class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :role
      t.integer :company_id
      t.boolean :is_banned, default: false, null: false

      t.timestamps
    end
  end
end
