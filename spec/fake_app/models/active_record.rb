# MODELS
class Product < ActiveRecord::Base
  belongs_to :company
end

class Company < ActiveRecord::Base
  has_many :products
end

# MIGRATIONS
class CreateAllTables < ActiveRecord::Migration
  def self.up
    create_table(:products) { |t| t.string :name; t.text :description; t.integer :company_id }
    create_table(:companies) { |t| t.string :name; t.text :description }
  end

  def self.down
    drop_table :products
    drop_table :companies
  end
end

ActiveRecord::Migration.verbose = false
CreateAllTables.up