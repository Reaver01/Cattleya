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
        event.respond "Saving data and shutting down... I'll be back."
        BOT.stop
        exit
      end
    end
  end
end
