configs = YAML.load_file('config/database.yml')
ActiveRecord::Base.configurations = configs

db_name = ENV['DB'] || 'sqlite'
ActiveRecord::Base.establish_connection(db_name)