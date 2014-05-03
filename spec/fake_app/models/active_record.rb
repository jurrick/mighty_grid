class Product < ActiveRecord::Base
end

#migrations
class CreateAllTables < ActiveRecord::Migration
  def self.up
    create_table(:products) { |t| t.string :name }
  end
end
ActiveRecord::Migration.verbose = false
CreateAllTables.up