#!/usr/bin/env ruby

# Zweiter Teil  http://net.tutsplus.com/tutorials/ruby/singing-with-sinatra/
# HomePage http://www.sinatrarb.com/
# Abgesicherten Bereich https://github.com/integrity/sinatra-authorization
# ActiveRecord migrations: http://www.sinatrarb.com/faq.html#ar-migrations
# Add erubis for auto escaping HTML http://www.sinatrarb.com/faq.html#auto_escape_html
# Übersetzung: https://github.com/ai/r18n https://github.com/sinefunc/sinatra-i18n
# Beispiel unter https://github.com/ai/r18n/tree/master/sinatra-r18n

require 'rubygems'
require 'sinatra'  
require 'data_mapper'
require 'builder'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/recall.db")  
  
class Note  
  include DataMapper::Resource  
  property :id, Serial  
  property :content, Text, :required => true  
  property :complete, Boolean, :required => true, :default => false  
  property :created_at, DateTime  
  property :updated_at, DateTime  
end  
  
DataMapper.finalize.auto_upgrade!  

    helpers do  
        include Rack::Utils  
        alias_method :h, :escape_html  
    end  


    get '/' do  
      @notes = Note.all :order => :id.desc  
      @title = 'All Notes'  
      erb :home  # will evaluate views/home.erb
    end  

post '/' do  
  puts "Taking note"
  n = Note.new  
  n.content = params[:content]  
  n.created_at = Time.now  
  n.updated_at = Time.now  
  n.save  
  puts "redirecting"
  redirect '/'  
  puts "redirect done"
end  

get '/rss.xml' do  
    @notes = Note.all :order => :id.desc  
    builder :rss  
end  


get '/:id' do  
  @note = Note.get params[:id]  
  @title = "Edit note ##{params[:id]}"  
  erb :edit  
end  

put '/:id' do  
  n = Note.get params[:id]  
  n.content = params[:content]  
  n.complete = params[:complete] ? 1 : 0  
  n.updated_at = Time.now  
  n.save  
  redirect '/'  
end  

get '/:id/delete' do  
  @note = Note.get params[:id]  
  @title = "Confirm deletion of note ##{params[:id]}"  
  erb :delete  
end  

delete '/:id' do  
  n = Note.get params[:id]  
  n.destroy  
  redirect '/'  
end  

get '/:id/complete' do  
  n = Note.get params[:id]  
  n.complete = n.complete ? 0 : 1 # flip it  
  n.updated_at = Time.now  
  n.save  
  redirect '/'  
end  
