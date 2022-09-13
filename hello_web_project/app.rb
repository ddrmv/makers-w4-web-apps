require 'sinatra/base'
require 'sinatra/reloader'

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    return "Hello"
  end

  get '/greet' do
    return params[:name] * params[:times].to_i
  end

  get '/names' do
    return "Julia, Mary, Karim"
  end

  post '/sort-names' do
    names = params[:names].split(',')
    sorted_names = names.sort.join(',')
    return sorted_names
  end

  # get '/' do
  #   name = params[:name]
  #   return "Hello #{name}"
  # end

  # post '/hello' do
  #   name = params[:name]
  #   return "Hello #{name}"
  # end

  # get '/hello' do
  #   return "Hello #{params[:name]}"
  # end

  # post '/submit' do
  #   name = params[:name]
  #   message = params[:message]
  #   return "Thanks #{name}, you sent this message: \"#{message}\""
  # end

  get "/hello" do

    return erb(:index)
  end
end