module Bot
  module Commands
    # Command Name
    module MonsterInfo
      extend Discordrb::Commands::CommandContainer
      command(
        [:monsterinfo, :minfo, :mi],
        description: 'Responds with monster info'
      ) do |event|
        # Stores the monster object
        monster = Database::ActiveMonster.current(event.channel.id)

        # Checks if the monster object returned anything
        if monster
          # Sends the monster embed to the channel
          event.channel.send_temporary_message '', 30, nil, monster.info_embed
        else
          # Tells the channel there isn't a monster
          event.channel.send_temporary_message "There isn't a monster in this channel", 30
        end

        # Deletes the invoking message
        event.message.delete unless event.message.channel.pm?
        nil
      end
    end
  end
end
