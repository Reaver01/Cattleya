module Commands
  # Command Module
  module Inventory
    extend Discordrb::Commands::CommandContainer
    command(
      :inventory,
      description: 'Sends a PM with your current inventory',
      useage: 'inventory'
    ) do |event|
      begin
        BOT.user(event.user.id.to_s).pm.send_embed '', inventory(event.user.id.to_s, event.user.name.to_s)
        event.message.react('💬')
      rescue
        mute_log(event.user.id.to_s)
      end
      begin
        event.message.delete
      rescue
      end
      command_log('inventory', event.user.name)
      nil
    end
    command(
      :inv,
      description: 'Sends a PM with your current inventory',
      useage: 'inv'
    ) do |event|
      begin
        BOT.user(event.user.id.to_s).pm.send_embed '', inventory(event.user.id.to_s, event.user.name.to_s)
        event.message.react('💬')
      rescue
        mute_log(event.user.id.to_s)
      end
      begin
        event.message.delete
      rescue
      end
      command_log('inventory', event.user.name)
      nil
    end
  end
end
