app = File.expand_path(File.join(File.dirname(__FILE__), '..', 'recall.rb'))
puts app
require app  # <-- your sinatra app
require 'rspec'
require 'rack/test'

set :environment, :test

describe 'Das Programm des besten Schweizer Goldschmieds' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "Programm kann Englisch" do
    get '/'
    last_response.should be_ok
    last_response.body.should match /All Notes/
  end
  
  it "Programm kann Deutsch" do
    get '/'
    last_response.should be_ok
    last_response.body.should match /Alle Notizen/
  end
end