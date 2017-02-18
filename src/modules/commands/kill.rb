module Bot
  module Commands
    # Command Name
    module Kill
      extend Discordrb::Commands::CommandContainer
      command(
        [:kill, :k],
        description: 'Kills the bot',
        usage: 'kill',
        help_available: false,
        permission_level: 999
      ) do |event|
        # Stops the bot
        BOT.stop

        # Exits
        exit
      end
    end
  end
end
