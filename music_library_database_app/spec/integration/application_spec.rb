# frozen_string_literal: true

require 'spec_helper'
require 'rack/test'
require_relative '../../app'

def reset_albums_table
  seed_sql = File.read('spec/seeds/seeds_tables.sql')
  user = 'postgres'
  password = ENV['PGPASSWORD'].to_s
  database_name = 'music_library_test'
  connection = PG.connect({ host: '127.0.0.1', dbname: database_name, user: user, password: password })
  connection.exec(seed_sql)
end

describe Application do
  before(:each) do
    reset_albums_table
  end

  include Rack::Test::Methods
  let(:app) { Application.new }

  context 'POST /albums' do
    it 'creates a new album and returns 200 OK' do
      response = post('/albums', title: 'Voyage', release_year: 2022, artist_id: 2)
      expect(response.status).to eq 200
    end
  end

  context 'GET /albums/:id' do
    it 'gets an album by id returns 200 OK' do
      response = get('/albums/1')
      expect(response.status).to eq 200
      expect(response.body).to include '<h1>Doolittle</h1>'
      expect(response.body).to include 'Release year: 1989'
      expect(response.body).to include 'Artist: Pixies'
    end
  end

  context 'GET /albums' do
    it 'gets all albums and returns 200 OK' do
      response = get('/albums')
      expect(response.status).to eq 200
      expect(response.body).to include '<h1>Albums</h1>'
      expect(response.body).to include 'Doolittle'
      expect(response.body).to include 'Surfer Rosa'
      expect(response.body).to include 'Ring Ring'
    end
  end

  context 'GET /albums' do
    it 'gets a list of albums and returns 200 OK' do
      response = get('/albums')
      expect(response.status).to eq 200
      expect(response.body).to include '<a href="/album/1">Doolittle</a>'
      expect(response.body).to include '<a href="/album/12">Ring Ring</a>'
    end
  end

  context 'POST /artists' do
    it 'creates a new artist record and returns 200 OK' do
      response = post('/artists', name: 'Wild nothing', genre: 'Indie')
      expect(response.status).to eq 200
      new_response = get('/artists')
      expect(new_response.status).to eq 200
      # expect(new_response.body).to eq 'Pixies, ABBA, Taylor Swift, ' \
      #   'Nina Simone, Wild nothing'
    end
  end

  context 'GET /artists/:id' do
    it 'returns artist by id and 200 OK' do
      response = get('/artists/2')
      expect(response.status).to eq 200
      expect(response.body).to include '<h1>ABBA</h1>'
    end
  end

  context 'GET /artists' do
    it 'returns list of artists with links and 200 Ok' do
      response = get('/artists')
      expect(response.status).to eq 200
      expect(response.body).to include '<a href="/artists/2">ABBA</a>'
    end
  end
end
