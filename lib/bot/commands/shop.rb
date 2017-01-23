module Commands
  # Command Module
  module Shop
    extend Discordrb::Commands::CommandContainer
    command(
      :shop,
      description: 'Displays shop listing',
      useage: 'shop'
    ) do |event|
      begin
        BOT.user(event.user.id.to_s).pm.send_embed '', shop(ITEMS)
        event_message.react('💬')
      rescue
        mute_log(event.user.id.to_s)
      end
      command_log('shop', event.user.name)
      nil
    end
  end
end
