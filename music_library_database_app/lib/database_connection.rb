# frozen_string_literal: true

# file: lib/database_connection.rb

require 'pg'

# This class is a thin "wrapper" around the
# PG library. We'll use it in our project to interact
# with the database using SQL.

class DatabaseConnection
  def self.connect
    db_name = ENV['ENV'] == 'test' ? 'music_library_test' : 'music_library'
    user = 'postgres'
    password = ENV['PGPASSWORD'].to_s
    @connection = PG.connect({ host: '127.0.0.1', dbname: db_name, user: user, password: password })
    # @connection = PG.connect({ host: '127.0.0.1', dbname: database_name })
  end

  def self.exec_params(query, params)
    if @connection.nil?
      raise 'DatabaseConnection.exec_params: Cannot run a SQL query as the connection to'\
      'the database was never opened. Did you make sure to call first the method '\
      '`DatabaseConnection.connect` in your app.rb file (or in your tests spec_helper.rb)?'
    end
    @connection.exec_params(query, params)
  end
end
