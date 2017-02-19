module Bot
  module Commands
    # Command Name
    module Spawn
      extend Discordrb::Commands::CommandContainer
      command(
        :spawn,
        description: 'Spawns a monster',
        usage: 'spawn',
        help_available: false,
        permission_level: 999
      ) do |event|
        current_monster = Database::ActiveMonster.current(event.channel.id)
        spawned_monster = Database::ActiveMonster.spawn(event.channel.id)
        unless current_monster
          BOT.channel(event.channel.id).send_embed(
            'A Monster has entered the channel!',
            spawned_monster.initial_embed
          )
        end
      end
    end
  end
end
