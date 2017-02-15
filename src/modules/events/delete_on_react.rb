module Bot
  module Events
    # Reaction event
    module Reactions
      extend Discordrb::EventContainer
      reaction_add(emoji: "\u274C") do |event|
        next unless event.emoji.name == "\u274C"
        next unless event.message.from_bot?
        event.message.delete
      end
    end
  end
end
