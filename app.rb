# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
require 'sinatra/activerecord'
require 'pony'

set :database, "sqlite3:db.sqlite"

class Customer < ActiveRecord::Base
  validates :name, presence: true, length: { minimum: 2 }
  validates :phone, presence: true
  validates :barber, presence: true
  validates :dateandtime, presence: true
end

class Barber < ActiveRecord:: Base
end

configure do
end

before do
  @barbers = Barber.all
end

get '/' do
  erb :index
end

get '/barbers' do
  erb :barbers
end

get '/barber/:id' do
  @barber = Barber.find(params[:id])

  erb :barber
end

get '/ticket' do
  @c = Customer.new
  erb :ticket
end

post '/ticket' do
  @c = Customer.new params[:customer]
  if @c.save
    return erb '<hr class="featurette-divider">
      ¡Gracias! El ticket está creado.
      <hr class="featurette-divider\>'
  end

  @error = @c.errors.full_messages.first
  erb :contact
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
    :to          => 'username@gmail.com',
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

  erb '<hr class="featurette-divider">
    ¡Gracias! Email sido enviado.
    <hr class="featurette-divider">'
end

get '/customers' do
  @customers = Customer.order "created_at DESC"

  erb :customers
end