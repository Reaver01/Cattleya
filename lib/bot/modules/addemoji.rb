# Responds to emoji being added
module Events
  extend Discordrb::EventContainer
  reaction_add(emoji: "\u274C") do |event|
    next unless event.emoji.name == "\u274C"
    next unless event.message.from_bot?
    puts 'Reaction was placed on bot'
    event.message.delete
  end
end
