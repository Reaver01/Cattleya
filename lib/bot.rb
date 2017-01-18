#create botfiles directory if it doesn't exist
unless File.exist?("botfiles")
	Dir.mkdir("botfiles")
end

#load env variables
Dotenv.load

#load other variables
SETTINGS = Hash.new
SETTINGS = LoadJSON(SETTINGS, "botfiles/settings.json")
PLAYERS = Hash.new
PLAYERS = LoadJSON(PLAYERS, "botfiles/players.json")
UNSTABLE = Hash.new
UNSTABLE = LoadJSON(UNSTABLE, "botfiles/unstable.json")
CURRENT_UNSTABLE = Hash.new
CURRENT_UNSTABLE = LoadJSON(CURRENT_UNSTABLE, "botfiles/curunst.json")

#sets bot prefix
PREFIX = '>'

#Loads and establishes BOT object
BOT = Discordrb::Commands::CommandBot.new token: ENV['TOKEN'], client_id: ENV['CLIENT'], prefix: PREFIX, advanced_functionality: false

#Load permissions from file
permissions = Hash.new
permissions = LoadPermissions(permissions,"botfiles/permissions.json")
permissions.each do |key, value|
	BOT.set_user_permission(permissions[key]['id'], permissions[key]['lvl'])
end
puts "Permission Loaded!"

#Load all commands
Commands.constants.each do |x|
	BOT.include! Commands.const_get x
end

#Load events
BOT.include! Events

#Turn off debugging and run async
BOT.debug = false
BOT.run :async
	
#Set game status from file
if SETTINGS.has_key?('game')
	BOT.game = SETTINGS['game']
else
	BOT.game = 0
end

puts BOT.invite_url

#start cron
cronjobs_start

puts 'Cattleya ready to serve!'
BOT.sync
