module Commands
  # Command Module
  module Shop
    extend Discordrb::Commands::CommandContainer
    command(
      :shop,
      description: 'Displays shop listing',
      usage: 'shop'
    ) do |event|
      begin
        BOT.user(event.user.id.to_s).pm.send_embed '', shop(ITEMS)
      rescue
        mute_log(event.user.id.to_s)
      end
      event.message.delete unless event.message.channel.pm?
      command_log('shop', event.user.name)
      nil
    end
  end
end
