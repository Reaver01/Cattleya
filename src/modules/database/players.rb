module Bot
  module Database
    # Defines a human player of the game.
    class Player < Sequel::Model
      one_to_many :items

      include Levels

      def self.resolve_id(id)
        find(discord_id: id) || create(discord_id: id)
      end

      def info_embed
        embed = Discordrb::Webhooks::Embed.new
        username = BOT.parse_mention("<@#{discord_id}>").name
        avatar = BOT.parse_mention("<@#{discord_id}>").avatar_url
        embed.title = "This is info all about #{username}!"
        embed.thumbnail = { url: avatar }
        embed.color = rand(0xffffff)
        embed.description = "**Level:** #{level}\n**HR:** #{hr}\n**XP:** " \
          "#{xp}\n**Current HP:** #{hp}\n**Zenny:** #{zenny}\n**Inventory:** " \
          "*placeholder* items"
        embed.timestamp = Time.now
        embed
      end
    end
  end
end
