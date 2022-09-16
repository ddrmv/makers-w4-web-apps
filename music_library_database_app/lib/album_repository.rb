# frozen_string_literal: true

require_relative 'album'

class AlbumRepository
  def all
    sql = 'SELECT id, title, release_year, artist_id FROM albums;'
    result_set = DatabaseConnection.exec_params(sql, [])
    result_set.map do |record|
      album = Album.new
      album.id = record['id'].to_i
      album.title = record['title']
      album.release_year = record['release_year']
      album.artist_id = record['artist_id'].to_i
      album
    end
  end

  def find(id)
    sql = 'SELECT id, title, release_year, artist_id FROM albums WHERE id = $1;'
    result_set = DatabaseConnection.exec_params(sql, [id])

    album = Album.new
    album.id = result_set[0]['id'].to_i
    album.title = result_set[0]['title']
    album.release_year = result_set[0]['release_year']
    album.artist_id = result_set[0]['artist_id'].to_i
    album
  end

  def create(album)
    sql = 'INSERT INTO albums (title, release_year, artist_id) VALUES ($1, $2, $3);'
    DatabaseConnection.exec_params(sql, [album.title, album.release_year,
                                         album.artist_id])
    nil
  end

  def delete(id)
    sql = 'DELETE FROM albums WHERE id = $1;'
    DatabaseConnection.exec_params(sql, [id])
  end
end
