module Bot
  module Commands
    # Command Name
    module Info
      extend Discordrb::Commands::CommandContainer
      command(
        [:info, :i],
        bucket: :info,
        description: 'Responds with player info',
        usage: 'info'
      ) do |event, mention|
        user_id = event.user.id
        unless BOT.parse_mention(mention).nil?
          user_id = if BOT.user(BOT.parse_mention(mention).id).bot_account?
                      event.user.id
                    else
                      BOT.parse_mention(mention).id
                    end
        end
        event.channel.send_embed(
          '', Database::Player.resolve_id(user_id).info_embed
        )
        event.message.delete unless event.message.channel.pm?
        nil
      end
    end
  end
end
