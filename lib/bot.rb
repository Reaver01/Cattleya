#create botfiles directory if it doesn't exist
unless File.exist?("botfiles")
	Dir.mkdir("botfiles")
end

#load env variables
Dotenv.load

#load other variables
$settings = Hash.new
$settings = loadJSON($settings, "botfiles/settings.json")
$players = Hash.new
$players = loadJSON($players, "botfiles/players.json")
$unstable = Hash.new
$unstable = loadJSON($unstable, "botfiles/unstable.json")
$curunst = Hash.new
$curunst = loadJSON($curunst, "botfiles/curunst.json")

#sets bot prefix
$prefix = '>'

#Loads and establishes $bot object
$bot = Discordrb::Commands::CommandBot.new token: ENV['TOKEN'], client_id: ENV['CLIENT'], prefix: $prefix, advanced_functionality: false

#Load permissions from file
permissions = Hash.new
permissions = loadPERM(permissions,"botfiles/permissions.json")
permissions.each do |key, value|
	$bot.set_user_permission(permissions[key]['id'], permissions[key]['lvl'])
end
puts "Permission Loaded!"

#Load all commands
Commands.constants.each do |x|
	$bot.include! Commands.const_get x
end

#Load events
$bot.include! Events

#Turn off debugging and run async
$bot.debug = false
$bot.run :async
	
#Set game status from file
if $settings.has_key?('game')
	$bot.game = $settings['game']
else
	$bot.game = 0
end

puts $bot.invite_url

#start cron
cronjobs_start

puts 'Cattleya ready to serve!'
$bot.sync
