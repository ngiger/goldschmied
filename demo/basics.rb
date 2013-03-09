#!/usr/bin/env ruby

# Erster Teil aus http://net.tutsplus.com/tutorials/ruby/singing-with-sinatra/

require 'rubygems'
require 'sinatra'  

get '/about' do  
  'A little about me.'  
end 

get '/hello/:name' do  
  "Hello there, #{params[:name]}."
end

get '/hello/:name/:city' do  
  "Hey there #{params[:name]} from #{params[:city]}."  
end

get '/form' do  
  erb :form  
end  

post '/form' do  
  "You said '#{params[:message]}'"  
end  

get '/secret' do  
  erb :secret  
end  

post '/secret' do  
  params[:secret].reverse  
end 

    not_found do  
  status 404  
  'not found'  
end  
