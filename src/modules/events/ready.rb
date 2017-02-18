module Bot
  module Events
    # Ready event
    module Ready
      extend Discordrb::EventContainer
      ready do |event|
        # Set game text
        event.bot.game = 'with monsters!'

        # Tell the console BOT is ready
        puts 'BOT Ready!'
      end
    end
  end
end
