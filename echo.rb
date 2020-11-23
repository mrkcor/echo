require 'bundler/setup'
require 'sinatra/base'
require 'cgi'

class Echo < Sinatra::Base
  get '/' do
    erb :form, locals: {message: nil}
  end

  post '/' do
    erb :form, locals: {message: params[:message]}
  end
end
