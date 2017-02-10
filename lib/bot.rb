# Make botfiles directory if the directory doesn't already exist
Dir.mkdir('botfiles') unless File.exist?('botfiles')
# Load the environment variables
Dotenv.load
# Set Miro options
Miro.options[:resolution] = '32x32'
Miro.options[:color_count] = 2
# Load all global variables
$cur_unst = load_json('botfiles/current_unstable.json')
$logs = load_json('botfiles/logs.json')
$players = load_json('botfiles/players.json')
$settings = load_json('botfiles/settings.json')
$unstable = load_json('botfiles/unstable.json')
$anger = %w(b l v y p w f g).sample
$hit = %w(c m u d n t e h i o a s r).sample
# If debug setting doesn't already exist then set it to false by default
$settings['debug'] = false unless $settings.key?('debug')
if $settings['debug']
  puts "[#{Time.now.strftime('%d %a %y | %H:%M:%S')}][STARTUP] Debugging mode" \
       ' on!'
else
  puts "[#{Time.now.strftime('%d %a %y | %H:%M:%S')}][STARTUP] Debugging mode" \
       ' off!'
end
# Load all constant variables
ARMOR = load_json('data/armor.json')
ITEMS = load_json('data/items.json')
MONSTERS = load_json('data/monsters.json')
PREFIX = '>'.freeze
# Load the bot constant
BOT = Discordrb::Commands::CommandBot.new token: ENV['TOKEN'],
                                          client_id: ENV['CLIENT'],
                                          prefix: PREFIX,
                                          advanced_functionality: false,
                                          ignore_bots: true,
                                          log_mode: :quiet
BOT.gateway.check_heartbeat_acks = true
# Load all permissions from file
permissions = load_permissions('botfiles/permissions.json')
permissions.each do |key, _value|
  BOT.set_user_permission(permissions[key]['id'], permissions[key]['lvl'])
end
puts "[#{Time.now.strftime('%d %a %y | %H:%M:%S')}][STARTUP] Permission Loaded!"
# Set up command buckets for rate limiting
BOT.bucket :item_use, limit: 3, time_span: 60, delay: 10
BOT.bucket :item_throw, limit: 3, time_span: 60, delay: 10
BOT.bucket :info, limit: 5, time_span: 60, delay: 5
BOT.bucket :reset, limit: 1, time_span: 60
# Load all command modules
Commands.constants.each do |x|
  BOT.include! Commands.const_get x
end
# Load outside event module
BOT.include! Events
# Turn off discordrb debugging
BOT.debug = false
# Set run to async
BOT.run :async
# Load game from settings and set to 0 if no game setting exists
BOT.game = if $settings.key?('game')
             $settings['game']
           else
             0
           end
# Put bot invite url in command console just in case
puts BOT.invite_url(permission_bits: 93_248)
puts "[#{Time.now.strftime('%d %a %y | %H:%M:%S')}][STARTUP] Cattleya ready " \
     'to serve!'
# Sync the bot object
BOT.sync
