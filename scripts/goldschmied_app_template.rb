# Use it like the following:
# padrino g project my_project --template /opt/src/goldschmied/scripts/goldschmied_app_template.rb
$root = File.dirname(File.dirname(__FILE__))
project :test => :shoulda, :renderer => :haml, :stylesheet => :sass, :script => :jquery, :orm => :datamapper
generate :plugin, 'will_paginate'

git :init, "."

def gitCommit(line, msg)
  FileUtils.rm_rf(Dir.glob('**/tmp'), :verbose => false)
  git :add, "*"
  git :commit, "-a -m '#{line}: #{msg}'"
end
gitCommit(__LINE__, 'msg')

# Default routes
APP_INIT = <<-APP
  get "/" do
    "Web-basiertes Programm für Goldschmiede"
  end

  get :about, :map => '/about_us' do
    render :haml, "%p Siehe https://github.com/ngiger/goldschmied"
  end
APP
inject_into_file 'app/app.rb', APP_INIT, :before => "#\n  end\n"
inject_into_file 'Gemfile', "gem 'bcrypt-ruby', :require => 'bcrypt'\n", :after => "# Component requirements\n"
gsub_file('config/boot.rb', /^.*I18n.default_locale = :en\n/, "I18n.default_locale = :de\n")
inject_into_file 'config/boot.rb', "  I18n.locale = :de\n", :after => "Padrino.before_load do\n"
create_file ".gitignore", "tmp
"

# Add some more stuff
run_bundler
gitCommit(__LINE__, 'after run_bundler')
generate :admin
gitCommit(__LINE__, 'generate :admin')

# bundle install
rake "dm:migrate"
gitCommit(__LINE__, 'dm:migrate')
remove_file "db/seeds.rb"
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
gitCommit(__LINE__, 'db/seeds.rb')
rake "db:seed"
gitCommit(__LINE__, 'db:seeds')

# appending timestamps to contact model
generate :model, "contact adrNumIndex:string name:string vorname:string isPerson:boolean titel:string bild1:string bild2:string"
gitCommit(__LINE__, 'generate :model, "contact')

# appending timestamps to post model
#      column :role, DataMapper::Property::String, :length => 255
inject_into_file 'models/contact.rb',  "# Timestamp info
  property :created_at,   DateTime
  property :created_on,   Date
  property :updated_at,   DateTime
  property :updated_on,   Date
", :after => "property :bild2, String\n"                 

rake 'dm:migrate'
gitCommit(__LINE__, 'dm:migrate')

# Generating contacts controller
generate :controller, "contacts get:index get:show"
gsub_file('app/controllers/contacts.rb', /^\s+\#\s+.*\n/,'')
POST_INDEX_ROUTE = <<-POST
      @contacts = Contact.all(:order => 'created_at desc')
      render 'contacts/index'
POST
POST_SHOW_ROUTE = <<-POST
      @contact = Contact.find_by_id(params[:id])
      render 'contacts/show'
POST
inject_into_file 'app/controllers/contacts.rb', POST_INDEX_ROUTE, :after => "get :index do\n"
inject_into_file 'app/controllers/contacts.rb', POST_SHOW_ROUTE, :after => "get :show do\n"
inject_into_file 'app/controllers/contacts.rb', ", :with => :id", :after => "get :show" # doesn't run?

# Generate admin_page for contact
gitCommit(__LINE__, 'inject_into_file app/controllers/contacts.rb')
generate :admin_page, "contact"

# Migrations to add account to contact
gitCommit(__LINE__, 'generate :admin_page, "contact"')
generate :migration, "AddAccountToContact account_id:integer"

# Update Contact Model with Validations and Associations
POST_MODEL = <<-POST
  belongs_to :account
#  validates_presence_of :name
#  validates_presence_of :vorname
  validates_presence_of :adrNumIndex
POST
inject_into_file 'models/contact.rb', POST_MODEL, :after => "DataMapper::Resource\n"
rake 'dm:migrate'
gitCommit(__LINE__, 'dm:migrate')

ADMIN_VIEW_INDEX = %(
.base-text
  %p Das Programm für Goldschmiede basiert auf \#{link_to 'Padrino', 'http://www.padrinorb.com/'}
  %p Wir hoffen, dass sie Spass daran haben, es zu benutzen
  %p Hier finden sie die Benutzer-Verwaltung
)

remove_file  'admin/views/base/index.haml'
create_file( 'admin/views/base/index.haml', ADMIN_VIEW_INDEX)

# Update admin app controller for contact
# inject_into_file 'admin/controllers/people.rb',"    @contact.account = current_account\n",:after => "new(params[:contact])\n"
# gitCommit(__LINE__, 'msg')

# Include RSS Feed
inject_into_file 'app/controllers/contacts.rb', ", :provides => [:html, :rss, :atom]", :after => "get :index"

# Create index.haml
POST_INDEX = <<-POST
- @title = "Willkommen"

- content_for :include do
  = feed_tag(:rss, url(:people, :index, :format => :rss),:title => "RSS")
  = feed_tag(:atom, url(:people, :index, :format => :atom),:title => "ATOM")

#people= partial 'people/contact', :collection => @people
POST
create_file 'app/views/people/index.haml', POST_INDEX

# Create _contact.haml
POST_PARTIAL = <<-POST
.contact
  .vorname= link_to contact.vorname, url_for(:people, :show, :id => contact)
  .date= time_ago_in_words(contact.created_at || Time.now) + ' ago'
  .vorname= simple_format(@contact.vorname)
  .adrNumIndex= simple_format(@contact.adrNumIndex)
  .isPerson= @contact.isPerson
  .titel= @contact.titel
  .bild1= @contact.bild1
  .bild2= @contact.bild2
POST
create_file 'app/views/people/_contact.haml', POST_PARTIAL

# Create show.haml
POST_SHOW = <<-POST
- @title = @contact.title
#show
  .contact
    .name= @contact.name
    .vorname= @contact.vorname
    .date= time_ago_in_words(@contact.created_at || Time.now) + ' ago'
    .isPerson= @contact.isPerson
    .adrNumIndex= @contact.adrNumIndex
    .titel= @contact.titel
    .bild1= @contact.bild1
    .bild2= @contact.bild2
%p= link_to 'Zeige alle Contacten', url_for(:people, :index)
POST
create_file 'app/views/contacts/show.haml', POST_SHOW

APPLICATION = <<-LAYOUT
!!! Strict
%html
  %head
    %title= [@title, "Bespiel Goldschmied"].compact.join(" | ")
    = stylesheet_link_tag 'reset', 'application'
    = javascript_include_tag 'jquery', 'application'
    = yield_content :include
  %body
    #header
      %h1 Beispiel Goldschmied app
      %ul.menu
        %li= link_to 'Contacten', url_for(:contacts, :index)
    #container
      #main= yield
      #sidebar
        - form_tag url_for(:contacts, :index), :method => 'get'  do
          Suche nach:
          = text_field_tag 'query', :value => params[:query]
          = submit_tag 'Search'
        %p Recent Contacts
        %ul.bulleted
          %li Item 1 - Lorem ipsum dolorum itsum estem
          %li Item 2 - Lorem ipsum dolorum itsum estem
          %li Item 3 - Lorem ipsum dolorum itsum estem
        %p Categories
        %ul.bulleted
          %li Item 1 - Lorem ipsum dolorum itsum estem
          %li Item 2 - Lorem ipsum dolorum itsum estem
          %li Item 3 - Lorem ipsum dolorum itsum estem
        %p Latest Comments
        %ul.bulleted
          %li Item 1 - Lorem ipsum dolorum itsum estem
          %li Item 2 - Lorem ipsum dolorum itsum estem
          %li Item 3 - Lorem ipsum dolorum itsum estem
    #footer
      Copyright (c) 2013 Niklaus Giger <niklaus.giger@member.fsf.org>
LAYOUT
create_file 'app/views/layouts/application.haml', APPLICATION

get 'https://github.com/padrino/sample_blog/raw/master/public/stylesheets/reset.css', 'public/stylesheets/reset.css'
get "https://github.com/padrino/sample_blog/raw/master/app/stylesheets/application.sass", 'app/stylesheets/application.sass'

gitCommit(__LINE__, 'generated some files')
generate :model, "contactinfo type:integer value_1:string value_2:string"
#generate :migration, "AddContactToContactinfo contact_id:integer"
gitCommit(__LINE__, 'generate :model, "contactinfo')

# Update Post Model with Validations and Associations
remove_file 'models/contacttype.rb'
create_file 'models/contacttype.rb',  %(
class ContactType
  include DataMapper::Resource
  property :id,         Serial
  property :type,       Enum[ :internet, :email, :fax, :mobile, :phone], :default => :internet, :unique_index => :uniqe_contact_type
  property :language,   String, :length =>  3, :unique_index => :uniqe_contact_type, :auto_validation => true, :default => 'de' # ISO-Code
  property :value,      String, :length => 32, :default => 'E-Mail'
end
)

remove_file 'models/contactinfo.rb'
create_file 'models/contactinfo.rb',  %(
class ContactInfo
  include DataMapper::Resource
  property :id,         Serial
  property :created_at,   DateTime
  property :created_on,   Date
  property :updated_at,   DateTime
  property :updated_on,   Date
  belongs_to              :contact
  property :type,       Enum[ :internet, :email, :fax, :mobile, :phone], :default => :internet
  property :value_1,    String, :length =>  3
  property :value_2,    String, :length => 32
end
)

rake 'dm:migrate'
gitCommit(__LINE__, 'dm:migrat')
generate :model, "addresstype type:integer language:string value:string"
generate :model, "address type:integer text:string po_box:string strasse:string ortzusatz:string staat:string plz:string ort:string"
generate :migration, "AddContactToAddress contact_id:integer"

gitCommit(__LINE__, 'generate :migration, "AddContactToAddress')
remove_file('models/addresstype.rb')
create_file('models/addresstype.rb', %(
# main, bill_to, delivery, other
class AddressType
  include DataMapper::Resource
  property :id,         Serial
  property :type,       Enum[ :main, :bill_to, :delivery, :other ], :default => :main, :unique_index => :uniqe_address_type
  property :language,   String, :length =>  3, :unique_index => :uniqe_address_type, :auto_validation => true, :default => 'de' # ISO-Code
  property :value,      String, :length => 32, :default => 'Hauptadresse'
end

))
# Update Post Model with Validations and Associations
inject_into_file 'models/address.rb', %(
  belongs_to :contact
  has       1,            :addressType, :through => Resource
#  validates_presence_of :type
#  validates_presence_of :ort
  # Timestamp info  
  property :created_at,   DateTime
  property :created_on,   Date
  property :updated_at,   DateTime
  property :updated_on,   Date
), :after => "DataMapper::Resource\n"

gsub_file('models/address.rb', 
          'property :type, Integer', 
          'property :type, Enum[ :main, :bill_to, :delivery, :other ], :default => :main, :unique_index => :uniqe_address_type')

inject_into_file 'models/contact.rb', %(
  has n, :addresses,    :through => Resource
  has n, :contactInfos, :through => Resource
), :after => "validates_presence_of :adrNumIndex\n"

rake 'dm:migrate'
                
gitCommit(__LINE__, 'm:migrate')

remove_file "db/seeds.rb"
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

rake 'dm:auto:upgrade'

puts 'done'
