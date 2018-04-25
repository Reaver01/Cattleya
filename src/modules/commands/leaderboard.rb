module Bot
  module Commands
    # Command Name
    module Leaderboard
      extend Discordrb::Commands::CommandContainer
      command(
        [:leaderboard, :l, :leader],
        description: 'Responds with top 10 hunters',
        usage: 'leaderboard'
      ) do |event|
        # Stores the database in temp and sorts it by level
        temp = Database::Player.sort_by { |player| player.level }.reverse

        # Posts the leaderboard
        10.times { |i| event << "#{BOT.user(temp[i].discord_id).name} - #{temp[i].level}" }

        nil
      end
    end
  end
end
