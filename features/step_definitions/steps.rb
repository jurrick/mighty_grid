Given /^I generate (\d+) users$/ do |n|
  1.upto(n.to_i) {|i| User.create! :name => "user#{'%03d' % i}" }
  User.create! :name => "admin#{'%03d' % 1}", role: :admin
  User.create! :name => "user#{'%03d' % (n.to_i + 1)}", is_banned: true
end