# Responds to emoji being added
module Events
  extend Discordrb::EventContainer
  reaction_add(emoji: "\u274C") do |event|
    puts event.message.author
  end
end
