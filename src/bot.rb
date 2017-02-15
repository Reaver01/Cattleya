require 'bundler/setup'
require 'discordrb'
require 'discordrb/data'
require 'dotenv'
require 'rufus-scheduler'

# The main bot module
module Bot
  # Load SCHEDULER
  SCHEDULER = Rufus::Scheduler.new

  # Load helpers
  Dir['src/helpers/*.rb'].each { |file| load file }

  # Make directories if they don't already exist
  Dir.mkdir('botfiles') unless File.exist?('botfiles')
  Dir.mkdir('database') unless File.exist?('database')

  # Load hit and anger variables
  $anger = %w(b l v y p w f g).sample
  $hit = %w(c m u d n t e h i o a s r).sample

  # Load other constant variables
  ITEMS = load_json('data/items.json')
  MONSTERS = load_json('data/monsters.json')
  PREFIX = ','.freeze

  # Load Modules
  Dir['src/modules/*.rb'].each { |file| load file }

  # Load the environment variables
  Dotenv.load

  # Load the bot as a constant
  BOT = Discordrb::Commands::CommandBot.new client_id: ENV['CLIENT'],
                                            token: ENV['TOKEN'],
                                            prefix: PREFIX,
                                            advanced_functionality: false,
                                            ignore_bots: true

  # Set permissions
  BOT.set_user_permission(ENV['OWNER'].to_i, 999)

  # Set up command buckets for rate limiting
  BOT.bucket :item_use, limit: 3, time_span: 60, delay: 10
  BOT.bucket :item_throw, limit: 3, time_span: 60, delay: 10
  BOT.bucket :info, limit: 5, time_span: 60, delay: 5
  BOT.bucket :reset, limit: 1, time_span: 60

  # Load all command modules
  Dir['src/modules/commands/*.rb'].each { |mod| load mod }
  Commands.constants.each { |mod| BOT.include! Commands.const_get mod }

  # Load all event modules
  Dir['src/modules/events/*.rb'].each { |mod| load mod }
  Events.constants.each { |mod| BOT.include! Events.const_get mod }

  # Run bot
  BOT.run
end
