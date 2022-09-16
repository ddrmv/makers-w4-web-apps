# file: app.rb
# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

  post '/albums' do
    repo = AlbumRepository.new
    album = Album.new
    album.title = params[:title]
    album.release_year = params[:release_year]
    album.artist_id = params[:artist_id]
    repo.create(album)
  end

  get '/albums' do
    repo = AlbumRepository.new
    @albums = repo.all
    return erb(:albums)
  end

  get '/albums/:id' do
    repo = AlbumRepository.new
    @album = repo.find(params[:id])
    @artist = ArtistRepository.new.find(@album.artist_id)
    return erb(:album)
  end

  get '/artists' do
    @artists = ArtistRepository.new.all
    return erb(:artists)
  end

  post '/artists' do
    new_artist = Artist.new
    new_artist.name = params[:name]
    new_artist.genre = params[:genre]
    ArtistRepository.new.create(new_artist)
    return nil
  end

  get '/artists/:id' do
    repo = ArtistRepository.new
    @artist = repo.find(params[:id])
    return erb(:artist)
  end
end
