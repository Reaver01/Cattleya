module Bot
  module Events
    # Ready event
    module Ready
      extend Discordrb::EventContainer
      ready do |event|
        event.bot.game = 'with monsters!'
        puts 'BOT Ready!'
      end
    end
  end
end
