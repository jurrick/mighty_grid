# MODELS
class User < ActiveRecord::Base
  belongs_to :company
end

class Company < ActiveRecord::Base
  has_many :users
end

# MIGRATIONS
class CreateAllTables < ActiveRecord::Migration
  def self.up
    create_table(:users) { |t| t.string :name; t.string :role; t.integer :company_id; t.boolean :is_banned, default: false, null: false }
    create_table(:companies) { |t| t.string :name; }
  end

  def self.down
    drop_table :users
    drop_table :companies
  end
end

CreateAllTables.down if User.table_exists? || Company.table_exists?
ActiveRecord::Migration.verbose = false
CreateAllTables.up