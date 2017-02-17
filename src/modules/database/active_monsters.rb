module Bot
  module Database
    # Active Monster table
    class ActiveMonster < Sequel::Model
      many_to_one :monster
      one_to_many :monster_attackers

      include Anger

      include Trap

      def self.spawn(channel)
        { new_monster: false, monster: find(channel: channel) } || create_monster(channel)
      end

      def create_monster(channel)
        {
          new_monster: true,
          monster: create(
            channel: channel, monster_id: Database::Monster[rand(1..Database::Monster.count)].id
          )
        }
      end

      def attack(player_id)
        monster_attackers.find { |i| i.player_id == player_id }
      end

      def add_attack(discord_id, damage_done = 1)
        player_id = Database::Player.resolve_id(discord_id).id
        existing_attack = attack(player_id)
        if existing_attack
          damage_done += existing_attack.damage_done
          existing_attack.update damage_done: damage_done
        else
          add_monster_attacker player_id: player_id, damage_done: damage_done
        end
      end

      def damage
        monster_attackers.map(&:damage_done).reduce(:+) || 0
      end

      def hp
        monster.hp - damage
      end

      def hp_percent
        percent = hp / monster.hp * 100
        percent.round
      end

      def health
        if hp_percent >= 60
          %w(Strong Healthy).sample
        elsif (20...60).cover? hp_percent
          %w(Wounded Damaged).sample
        else
          %w(Limping Weak Feable Dying).sample
        end
      end

      def self.current(channel)
        find(channel: channel) || false
      end

      # @return [object] embed
      def info_embed
        embed = Discordrb::Webhooks::Embed.new
        embed.title = monster.name
        embed.thumbnail = {
          url: "http://monsterhunteronline.in/monsters/images/#{monster.icon}.png"
        }
        embed.color = monster.color
        embed.description = "Angry: #{angry? ? 'Yes' : 'No'}\n" \
                            "In Trap: #{trapped? ? 'Yes' : 'No'}\n" \
                            "Status: #{health}"
        embed.timestamp = Time.now
        embed
      end

      # @return [object] embed
      def initial_embed
        embed = Discordrb::Webhooks::Embed.new
        embed.title = monster.name
        embed.thumbnail = {
          url: "http://monsterhunteronline.in/monsters/images/#{monster.icon}.png"
        }
        embed.color = monster.color
        embed.description = 'Good Luck!'
        embed.timestamp = Time.now
        embed
      end
    end
  end
end
