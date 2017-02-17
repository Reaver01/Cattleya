module Bot
  module Commands
    # Command Name
    module Test
      extend Discordrb::Commands::CommandContainer
      command(
        [:test, :t]
      ) do |event|
        Database::ActiveMonster.current(event.channel.id).monster_attackers
      end
    end
  end
end
