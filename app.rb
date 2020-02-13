# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
require 'pony'

get '/' do
  erb :index
end

get '/ticket' do
end

post '/ticket' do
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

  @message = '¡Gracias! Email sido enviado.'

  erb :contact
end

get '/customers' do
end