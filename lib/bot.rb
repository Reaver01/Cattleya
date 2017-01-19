#create botfiles directory if it doesn't exist
unless File.exist?("botfiles")
	Dir.mkdir("botfiles")
end
#load env variables
Dotenv.load
#load other variables
$current_unstable = Hash.new
$current_unstable = LoadJSON($current_unstable, "botfiles/current_unstable.json")
$logs = Hash.new
$logs = LoadJSON($logs, "botfiles/logs.json")
$players = Hash.new
$players = LoadJSON($players, "botfiles/players.json")
$settings = Hash.new
$settings = LoadJSON($settings, "botfiles/settings.json")
$unstable = Hash.new
$unstable = LoadJSON($unstable, "botfiles/unstable.json")
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
if $settings.has_key?('game')
	BOT.game = $settings['game']
else
	BOT.game = 0
end
#displays the invite url in the console (just in case...)
puts BOT.invite_url
#start cron
cronjobs_start
puts 'Cattleya ready to serve!'
BOT.sync
