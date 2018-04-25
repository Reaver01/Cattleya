module Bot
  module Events
    # Ready event
    module Ready
      extend Discordrb::EventContainer
      ready do |_event|
        # Set game text
        BOT.game = 'with ' + Database::Monster[rand(1..Database::Monster.count)].name

        # Set hit and anger variables
        $anger = %w(b l v y p w f g).sample
        $hit = %w(c m u d n t e h i o a s r).sample
        
        #Store leaderboard variable
        $leaderboard = Database::Player.sort_by { |player| player.level }.reverse

        # Tell the console BOT is ready
        puts 'BOT Ready!'
      end
    end
  end
end
