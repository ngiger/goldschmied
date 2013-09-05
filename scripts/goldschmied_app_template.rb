# Use it like the following:
# padrino g project my_project --template /opt/src/goldschmied/scripts/my_template.rb
$root = File.dirname(File.dirname(__FILE__))
project :rspec => :shoulda, :orm => :datamapper, :stylesheet => :sass # , :template => :sampleblog 
puts "Dir.pwd"
git :init, "."
git :add, "."
git :commit, "-m 'initial commit'"

name1 = File.expand_path("#{$root}/admin/lib/data_schema.rb")
# inject_into_file "db/migrate/001_add_client_tables.rb", IO.read(name1)

require_dependencies 'will_paginate'
generate :admin

inject_into_file "db/seeds.rb", %(# db/seeds.rb
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
  shell.say "   email: #{email}"
  shell.say "   password: #{password}"
  shell.say "================================================================="
else
  shell.say "Sorry but some thing went worng!"
  shell.say ""
  account.errors.full_messages.each { |m| shell.say "   - #{m}" }
end

shell.say ""
)

rake "db:migrate"
rake "db:seed"

git :add, "."
git :commit, "-m 'after admin with db.seed'"

generate :model, "post title:string body:text"
generate :controller, "posts get:index get:new post:new"
git :add, "."
git :commit, "-m 'before AddAddress'"
generate :migration, "AddAddress plz:string" # creates db/migrate/xxx_add_email_to_user.rb
git :add, "."
git :commit, "-m 'after AddAddress'"
generate :admin_page, :post
require_dependencies 'nokogiri'

#  '$2a$10$xTEHikDnw3fZ/o8fgt/Zx.olqPlz.mWmoMD2u8guRvYEzoiyx5EbG'
inject_into_file "app/models/post.rb","#Hello", :after => "end\n"

git :add, "."
git :commit, "-m 'after nokogiri'"

exit 0
# initializer :test, "# Example"

# app :testapp do
#   generate :controller, "users get:index"
# end

git :add, "."
git :commit, "-m 'second commit"

x = %(
# we use the defaults from padrino, but stylesheet/test have no default
# which template should we use
padrino g project goldschmied -d datamapper -stylesheet sass -test rspec --template sampleblog # -renderer haml -adapter postgres
cd goldschmied/
padrino g plugin will_paginate && bundle
padrino g admin
bundle install
bundle exec rake db:migrate
bundle exec rake db:seedR
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