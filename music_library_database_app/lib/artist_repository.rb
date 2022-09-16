# frozen_string_literal: true

require_relative 'artist'

class ArtistRepository
  def all
    sql = 'SELECT id, name, genre FROM artists;'
    result_set = DatabaseConnection.exec_params(sql, [])
    result_set.map do |record|
      artist = Artist.new
      artist.id = record['id'].to_i
      artist.name = record['name']
      artist.genre = record['genre']
      artist
    end
  end

  def find(id)
    sql = 'SELECT id, name, genre FROM artists WHERE id = $1;'
    result_set = DatabaseConnection.exec_params(sql, [id])

    artist = Artist.new
    artist.id = result_set[0]['id'].to_i
    artist.name = result_set[0]['name']
    artist.genre = result_set[0]['genre']
    artist
  end

  def create(artist)
    sql = 'INSERT INTO artists (name, genre) VALUES ($1, $2);'
    DatabaseConnection.exec_params(sql, [artist.name, artist.genre])
    nil
  end
end
