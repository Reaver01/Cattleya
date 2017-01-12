require 'bundler/setup'
require 'active_support'
require 'date'
require 'discordrb'
require 'discordrb/data'
require 'dotenv'
require 'json'
require 'open-uri'
require 'rubygems'
require 'rufus-scheduler'
require 'sys/uptime'
require 'time'
require 'time_difference'
require 'yaml'
require 'titleize'
include Sys
require_relative 'lib/bot/extras/cron'
require_relative 'lib/bot/extras/arrays'
Dir["lib/bot/commands/*.rb"].each {|file| require_relative file }
require_relative 'lib/bot/class/loader'
require_relative 'lib/bot/class/embeds'
require_relative 'lib/bot/class/hash'
require_relative 'lib/bot/events/events'
require_relative 'lib/bot'
