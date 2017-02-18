module Bot
  module Commands
    # Command Name
    module Test
      extend Discordrb::Commands::CommandContainer
      command(
        [:test, :t]
      ) do |event|
        'this is a test'
      end
    end
  end
end
