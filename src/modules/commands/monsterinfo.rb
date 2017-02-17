module Bot
  module Commands
    # Command Name
    module MonsterInfo
      extend Discordrb::Commands::CommandContainer
      command(
        [:monsterinfo, :minfo, :mi],
        bucket: :info,
        description: 'Responds with monster info'
      ) do |event|
        monster = Database::ActiveMonster.current(event.channel.id)
        if monster
          event.channel.send_embed('', monster.info_embed)
        else
          event.respond "There isn't a monster in this channel"
        end
        event.message.delete unless event.message.channel.pm?
        nil
      end
    end
  end
end
