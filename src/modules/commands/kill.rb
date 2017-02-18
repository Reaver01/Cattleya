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
        # Sends a message to the channel
        event.channel.send_temporary_message "Saving data and shutting down... I'll be back.", 5

        # Stops the bot
        BOT.stop

        # Exits
        exit
      end
    end
  end
end
