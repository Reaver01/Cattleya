#create botfiles directory if it doesn't exist
unless File.exist?('botfiles')
	Dir.mkdir('botfiles')
end
#load env variables
Dotenv.load
#load other variables
$current_unstable = LoadJSON('botfiles/current_unstable.json')
$logs = LoadJSON('botfiles/logs.json')
$players = LoadJSON('botfiles/players.json')
$settings = LoadJSON('botfiles/settings.json')
$unstable = LoadJSON('botfiles/unstable.json')
$anger = ['b', 'l', 'v', 'y', 'p', 'w', 'f', 'g'].sample
$hit = ['c', 'm', 'u', 'd', 'n', 't', 'e', 'h', 'i', 'o', 'a', 's', 'r'].sample
unless $settings.has_key?('debug')
	$settings['debug'] = false
end
if $settings['debug']
	puts '[STARTUP] Debugging mode on!'
else
	puts '[STARTUP] Debugging mode off!'
end
ITEMS = LoadJSON('data/items.json')
MONSTERS = LoadJSON('data/monsters.json')
#sets bot prefix
PREFIX = '>'
#load modules
#Loads and establishes BOT object
BOT = Discordrb::Commands::CommandBot.new token: ENV['TOKEN'], client_id: ENV['CLIENT'], prefix: PREFIX, advanced_functionality: false, ignore_bots: true
#Load permissions from file
permissions = LoadPermissions('botfiles/permissions.json')
permissions.each do |key, value|
	BOT.set_user_permission(permissions[key]['id'], permissions[key]['lvl'])
end
puts '[STARTUP] Permission Loaded!'
#make buckets for commands
BOT.bucket :item_use, limit: 3, time_span: 60, delay: 10
BOT.bucket :info, limit: 5, time_span: 60, delay: 5
BOT.bucket :reset, limit: 1, time_span: 60
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
if $settings.has_key?('game')
	BOT.game = $settings['game']
else
	BOT.game = 0
end
#displays the invite url in the console (just in case...)
puts BOT.invite_url

puts '[STARTUP] Cattleya ready to serve!'
BOT.sync
