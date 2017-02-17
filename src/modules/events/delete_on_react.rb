module Bot
  module Events
    # Reaction event
    module Reactions
      extend Discordrb::EventContainer
      reaction_add(emoji: "\u274C") do |event|
        # Check if emoji is the :x: emoji
        next unless event.emoji.name == "\u274C"

        # Check if the message is from the bot
        next unless event.message.from_bot?

        # Delete the message
        event.message.delete
      end
    end
  end
end
