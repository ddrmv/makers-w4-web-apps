require 'sinatra/base'
require "sinatra/reloader"

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    return erb(:index)
  end

  post '/hello' do
    @name = validate_input(params[:name])

    return erb(:hello)
  end

  def validate_input(text)
    if text.index( /[^[:alnum:]]/ )
      return "Invalid name input."
    else
      return text
    end
  end
end
