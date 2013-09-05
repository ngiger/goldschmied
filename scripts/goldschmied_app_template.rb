# Use it like the following:
# padrino g project my_project --template /opt/src/goldschmied/scripts/goldschmied_app_template.rb
$root = File.dirname(File.dirname(__FILE__))
project :test => :shoulda, :renderer => :haml, :stylesheet => :sass, :script => :jquery, :orm => :datamapper
generate :plugin, 'will_paginate'
#generate :plugin, 'https://raw.github.com/padrino/padrino-recipes/master/plugins/will_paginate_plugin.rb'
# Default routes
APP_INIT = <<-APP
  get "/" do
    "Rolf Müllers neue Verwaltung"
  end

  get :about, :map => '/about_us' do
    render :haml, "%p This is a sample blog created to demonstrate the power of Padrino!"
  end
APP
inject_into_file 'app/app.rb', APP_INIT, :before => "#\n  end\n"

inject_into_file 'Gemfile', "gem 'bcrypt-ruby', :require => 'bcrypt'\n", :after => "# Component requirements\n"
inject_into_file 'config/boot.rb', "I18n.locale = :de\n", :after => "Padrino.before_load do\n"

# Add some more stuff
run_bundler
generate :admin

# bundle install

puts "after bundle"
rake "db:migrate"
puts "after migrate"
create_file "db/seeds.rb", %(# db/seeds.rb
email     = "niklaus.giger@hispeed.ch"
password  = "admin"

shell.say ""

account = Account.create(:email => email, 
                         :name => "Niklaus", 
                         :surname => "Giger", 
                         :password => password, 
                         :password_confirmation => password, 
                         :role => "admin")

if account.valid?
  shell.say "================================================================="
  shell.say "Account has been successfully created, now you can login with:"
  shell.say "================================================================="
  shell.say "   email: \#{email}"
  shell.say "   password: \#{password}"
  shell.say "================================================================="
else
  shell.say "Sorry but some thing went worng!"
  shell.say ""
  account.errors.full_messages.each { |m| shell.say "   - \#{m}" }
end

shell.say ""
)
puts "after inject"
rake "db:seed"
puts "after ssed"

git :add, "."
git :commit, "-a -m 'after admin with db.seed'"

puts "#{__FILE__} at #{__LINE__}"

generate :model, "post title:string body:text"
generate :controller, "posts get:index get:new post:new"
git :add, "."
git :commit, "-a -m 'before AddAddress'"
generate :migration, "AddAddress plz:string" # creates db/migrate/xxx_add_email_to_user.rb
git :add, "."
puts "#{__FILE__} at #{__LINE__}"
git :commit, "-a -m 'after AddAddress'"
puts "#{__FILE__} at #{__LINE__}"
generate :admin_page, :post
puts "#{__FILE__} at #{__LINE__}"
require_dependencies 'nokogiri'
puts "#{__FILE__} at #{__LINE__}"

#  '$2a$10$xTEHikDnw3fZ/o8fgt/Zx.olqPlz.mWmoMD2u8guRvYEzoiyx5EbG'
puts "#{__FILE__} at #{__LINE__}"
inject_into_file "app/models/post.rb","#Hello", :after => "end\n"
puts "#{__FILE__} at #{__LINE__}"

git :add, "."
git :commit, "-a -m 'after nokogiri'"

exit 0
# initializer :test, "# Example"

# app :testapp do
#   generate :controller, "users get:index"
# end

git :add, "."
git :commit, "-a -m 'second commit"

x = %(
# we use the defaults from padrino, but stylesheet/test have no default
# which template should we use
padrino g project goldschmied -d datamapper -stylesheet sass -test rspec --template sampleblog # -renderer haml -adapter postgres
cd goldschmied/
padrino g plugin will_paginate && bundle
padrino g admin
bundle install
bundle exec rake db:migrate
bundle exec rake db:seed
padrino g model post name:string body:text
padrino g admin_page post
padrino rake db:migrate
rake routes
padrino start
# http://www.padrinorb.com/guides/localization 
# dort gibt es Translate Models (ActiveRecord)
# https://github.com/ai/r18n
# padrino seems to use slim
# db/seeds.rb zum Lesen der Daten
)