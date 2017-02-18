module Bot
  module Commands
    # Command Name
    module Info
      extend Discordrb::Commands::CommandContainer
      command(
        [:info, :i],
        description: 'Responds with player info',
        usage: 'info'
      ) do |event, mention|
        # Stores the user id of the player
        user_id = event.user.id

        # Checks if there was a mention in the message
        unless BOT.parse_mention(mention).nil?
          # if the mention was not that of a bot sets the user id of the player mentioned
          user_id = if BOT.user(BOT.parse_mention(mention).id).bot_account?
                      event.user.id
                    else
                      BOT.parse_mention(mention).id
                    end
        end

        # Sends the info of the player to the channel
        event.channel.send_temporary_message(
          '', 30, nil, Database::Player.resolve_id(user_id).info_embed
        )

        # Deletes the invoking message
        event.message.delete unless event.message.channel.pm?
        nil
      end
    end
  end
end
