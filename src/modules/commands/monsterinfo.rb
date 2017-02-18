module Bot
  module Commands
    # Command Name
    module MonsterInfo
      extend Discordrb::Commands::CommandContainer
      command(
        [:monsterinfo, :minfo, :mi],
        description: 'Responds with monster info'
      ) do |event|
        monster = Database::ActiveMonster.current(event.channel.id)
        if monster
          event.channel.send_temporary_message '', 30, nil, monster.info_embed
        else
          event.channel.send_temporary_message "There isn't a monster in this channel", 30
        end
        event.message.delete unless event.message.channel.pm?
        nil
      end
    end
  end
end
