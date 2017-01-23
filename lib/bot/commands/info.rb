module Commands
  # Command Module
  module Info
    extend Discordrb::Commands::CommandContainer
    command(
      :info,
      bucket: :info,
      description: 'Responds with player info',
      useage: 'info'
    ) do |event, mention|
      user_id = event.user.id.to_s
      user_name = event.user.name.to_s
      avatar = event.user.avatar_url.to_s
      unless BOT.parse_mention(mention).nil?
        if BOT.user(BOT.parse_mention(mention).id).bot_account?
          user_id = event.user.id.to_s
          user_name = event.user.name.to_s
          avatar = event.user.avatar_url.to_s
        else
          user_id = BOT.parse_mention(mention).id.to_s
          user_name = BOT.parse_mention(mention).name.to_s
          avatar = BOT.parse_mention(mention).avatar_url.to_s
        end
      end
      begin
        event.channel.send_embed '', user_info(user_id, user_name, avatar)
      rescue
        mute_log(event.channel.id.to_s)
      end
      event.message.delete
      command_log('info', event.user.name)
      nil
    end
  end
end
