# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
require 'sinatra/activerecord'
require 'pony'

set :database, "sqlite3:db.sqlite"

class Customer < ActiveRecord::Base
end

#def init_db
#  db = SQLite3::Database.new 'db.sqlite'
#  db.results_as_hash = true
#  return db
#end

#def is_barber_exists?(db, name)
#  db.execute('SELECT * FROM Barbers WHERE barber=?', [name]).length > 0
#end

#def seed_db(db, barbers)
#  barbers.each do |barber|
#    if !is_barber_exists?(db, barber)
#      db.execute 'INSERT INTO Barbers (barber) VALUES (?)', [barber]
#    end
#  end
#end

configure do
  #db = init_db
  #db.execute 'CREATE TABLE IF NOT EXISTS Barbers (
  #  barber TEXT
  #)'
  #db.execute 'CREATE TABLE IF NOT EXISTS Customers (
  #  id INTEGER PRIMARY KEY AUTOINCREMENT,
  #  name TEXT,
  #  phone TEXT,
  #  barber TEXT,
  #  dateandtime TEXT,
  #  color TEXT
  #)'
  #seed_db(db, ['Alberto Cerdán', 'Josep Pons', 'Moncho Moreno', 'Lorena Morlote', 'Raffel Pages', 'Amparo Fernández', 'Olga García'])
end

before do
  #db = init_db
  #@barbers = db.execute 'SELECT * FROM Barbers'
end

get '/' do
  erb :about
end

get '/ticket' do
  erb :ticket
end

post '/ticket' do
  @name        = params[:name]
  @phone       = params[:phone]
  @barber      = params[:barber]
  @dateandtime = params[:datetimepicker]
  @color       = params[:colorpicker]

  hh = {:name        => 'Su nombre',
        :phone       => 'Su teléfono',
        :dateandtime => 'El día y la hora'}

  hh.each do |key, value|
    if params[key] == ''
      @error = hh[key]
      return erb :ticket if @error != ''
    end
  end

  #db = init_db
  #db.execute 'INSERT INTO Customers (name, phone, barber, dateandtime, color)
  #  VALUES (?, ?, ?, ?, ?)', [@name, @phone, @barber, @dateandtime, @color]

  erb "¡Gracias! Estimado/a #{@name}, te esperamos el día y la hora #{@dateandtime}"
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
    :from    => params[:name] + "<" + params[:email] + ">",
    :to      => 'username@example.com',
    :subject => params[:name] + " está comunicando",
    :body    => params[:message],
    :via     => :smtp,
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
  #db = init_db
  #@customers = db.execute 'SELECT * FROM Customers ORDER BY id DESC'

  erb :customers
end