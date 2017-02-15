require 'sequel'
require 'sqlite3'

module Bot
  # Database module for bot
  module Database
    # Connect to database
    DB = Sequel.connect('sqlite://data.db')

    DB.create_table?(:players) do
      primary_key :id
      Integer :playerid
      Integer :hr
      Integer :level
      Integer :xp
      Integer :max_hp
      Integer :hp
      Integer :zenny
      String :inventory
      String :time
      String :death_time
      TrueClass :notifications
    end

    class Player < Sequel::Model
    end
  end
end
