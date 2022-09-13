require "spec_helper"
require "rack/test"
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

  context "POST /albums" do
    it "creates a new album and returns 200 OK" do
      response = post("/albums", title: "Voyage", release_year: 2022, artist_id: 2)
      expect(response.status).to eq 200
    end
  end

  context "GET /albums/:id" do
    it "gets an album by id returns 200 OK" do
      response = get("/albums/1")
      expect(response.status).to eq 200
      expect(response.body).to include "<h1>Doolittle</h1>"
      expect(response.body).to include "Release year: 1989"
      expect(response.body).to include "Artist: Pixies"
    end
  end
end
