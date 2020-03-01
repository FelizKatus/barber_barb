# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
require 'sinatra/activerecord'
require 'pony'

set :database, "sqlite3:db.sqlite"

class Customer < ActiveRecord::Base
end

class Barber < ActiveRecord:: Base
end

configure do
end

before do
  @barbers = Barber.all
end

get '/' do
  erb :about
end

get '/barbers' do
  erb :barbers
end

get '/ticket' do
  erb :ticket
end

post '/ticket' do
  c = Customer.new params[:customer]
  c.save

  erb "¡Gracias! El ticket está creado."
end

get '/contact' do
  erb :contact
end

post '/contact' do
  @name    = params[:name]
  @email   = params[:email]
  @subject = params[:subject]
  @message = params[:message]

  hh = {:name    => 'Su nombre',
        :email   => 'Su email',
        :subject => 'Su subject',
        :message => 'su message'}

  hh.each do |key, value|
    if params[key] == ''
      @error = hh[key]
      return erb :contact if @error != ''
    end
  end

  Pony.mail(
    :from        => params[:name] + "<" + params[:email] + ">",
    :to          => 'username@example.com',
    :subject     => params[:name] + " está comunicando",
    :body        => params[:message],
    :via         => :smtp,
    :via_options => { 
      :address              => 'smtp.gmail.com', 
      :port                 => '587', 
      :enable_starttls_auto => true, 
      :user_name            => 'username', 
      :password             => 'password', 
      :authentication       => :plain, 
      :domain               => 'localhost.localdomain'
    })

  erb '¡Gracias! Email sido enviado.'
end

get '/customers' do
  @customers = Customer.order "created_at DESC"

  erb :customers
end