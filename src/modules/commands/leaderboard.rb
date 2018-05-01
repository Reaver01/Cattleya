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
        # Posts the leaderboard
        event << "**Here is the leaderboard!**"
        10.times { |i| event << "#{BOT.user($leaderboard[i].discord_id).name} - #{$leaderboard[i].level}" }
        nil
      end
    end
  end
end
