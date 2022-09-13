require 'spec_helper'
require 'rack/test'
require_relative '../../app'

RSpec.describe Application do
  include Rack::Test::Methods
  let(:app) { Application.new }

  context "GET /" do
    it "returns 200 with the right content" do
      response = get('/')

      expect(response.status).to eq 200
      expect(response.body).to eq "Hello"
    end

    it "returns 200 with the right content" do
      response = get('/greet', name: "Dana", times: 2)
      expect(response.status).to eq 200
      expect(response.body).to eq "DanaDana"
    end
  end

  context "GET /names" do
    it "returns 200 with body of three names" do
      response = get('/names')
      expect(response.status).to eq 200
      expect(response.body).to eq "Julia, Mary, Karim"
    end
  end

  context "POST /sort-names" do
    it "returns 200 with sorted names" do
      response = post('/sort-names', names: "Joe,Alice,Zoe,Julia,Kieran")
      expect(response.status).to eq 200
      expect(response.body).to eq "Alice,Joe,Julia,Kieran,Zoe"
    end
  end

  context "GET /hello" do
    it "returns 200 with body of HTML" do
      response = get('/hello')
      expect(response.status).to eq 200
      expect(response.body).to include("<h1>Hello!</h1>")
    end
  end

  
end