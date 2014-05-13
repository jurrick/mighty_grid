# MODELS
class Product < ActiveRecord::Base
end

# MIGRATIONS
class CreateAllTables < ActiveRecord::Migration
  def self.up
    create_table(:products) { |t| t.string :name; t.text :description }
  end
end

ActiveRecord::Migration.verbose = false
CreateAllTables.up