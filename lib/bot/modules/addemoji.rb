# Responds to emoji being added
module Events
  extend Discordrb::EventContainer
  reaction_add(emoji: "\u274C") do |event|
    next unless event.emoji.name == "\u274C"
    puts event.message.author
  end
end
