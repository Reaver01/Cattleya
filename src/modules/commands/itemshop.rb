module Bot
  module Commands
    # Command Module
    module Shop
      extend Discordrb::Commands::CommandContainer
      command(
        [:itemshop, :shop, :store, :s],
        description: 'Displays shop listing',
        usage: 'itemshop'
      ) do |event|
        # Creates an embed with the shop listing
        embed = Discordrb::Webhooks::Embed.new
        embed.title = 'Here is the shop listing!'
        embed.thumbnail = { url: BOT.profile.avatar_url }
        embed.color = rand(0xffffff)
        embed.description = ''
        Database::ItemDefinition.each do |item|
          embed.description += "**#{item.name}:** #{item.price}z\n"
        end
        embed.timestamp = Time.now

        # Sends the embed to the player
        begin
          event.user.pm.send_embed '', embed
        rescue
          puts 'Failed sending the inventory liting to a player'
        end

        # Deletes the invoking message
        event.message.delete unless event.message.channel.pm?
        nil
      end
    end
  end
end
