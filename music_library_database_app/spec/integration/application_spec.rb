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

  context "GET /albums" do
    it "gets an album by id returns 200 OK" do
      response = get("/albums")
      expect(response.status).to eq 200
      expect(response.body).to include "<h1>Albums</h1>"
      expect(response.body).to include "Title: Doolittle"
      expect(response.body).to include "Title: Surfer Rosa"
      expect(response.body).to include "Title: Ring Ring"
    end
  end

  context "GET /artists" do
    it "gets a list of artists and returns 200 OK" do
      response = get("/artists")
      expect(response.status).to eq 200
      expect(response.body).to include "<a href=\"/albums/1\" > Doolittle </a>"
      expect(response.body).to include "<a href=\"/albums/12\" > Ring Ring </a>"
    end
  end

  context "POST /artists" do
    it "creates a new artist record and returns 200 OK" do
      response = post("/artists", name: "Wild nothing", genre: "Indie")
      expect(response.status).to eq 200
      new_response = get("/artists")
      expect(new_response.status).to eq 200
      expect(new_response.body).to eq "Pixies, ABBA, Taylor Swift, " \
        "Nina Simone, Wild nothing"
    end
  end

  
end
