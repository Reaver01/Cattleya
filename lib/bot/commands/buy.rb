module Commands
  # Command Module
  module Buy
    extend Discordrb::Commands::CommandContainer
    command(
      :buy,
      bucket: :item_use,
      description: 'Buys an item from the shop',
      usage: 'buy',
      min_args: 1,
      max_args: 2
    ) do |event, option_number, amount = 1|
      amount = 1 if amount.to_i < 1
      amount = amount.to_i.round
      option_number = option_number.to_i.round
      if option_number < 1 || option_number > ITEMS.length - 1
        begin
          event.respond 'That is not a valid option'
        rescue
          mute_log(event.channel.id.to_s)
        end
      elsif $players.key?(event.user.id.to_s)
        if $players[event.user.id.to_s]['zenny'].to_i < (ITEMS[option_number - 1]['price'].to_i * amount.to_i)
          begin
            event.respond "You don't have enough Zenny to purchase #{amount} #{ITEMS[option_number - 1]['name']}"
          rescue
            mute_log(event.channel.id.to_s)
          end
        else
          $players[event.user.id.to_s]['zenny'] -= ITEMS[option_number - 1]['price'] * amount
          if $players[event.user.id.to_s]['inv'].key?((option_number - 1).to_s)
            $players[event.user.id.to_s]['inv'][(option_number - 1).to_s] += 1 * amount
          else
            $players[event.user.id.to_s]['inv'][(option_number - 1).to_s] = 1 * amount
          end
          begin
            event.respond "**#{event.user.name}** purchased **#{amount} #{ITEMS[option_number - 1]['name']}**"
          rescue
            mute_log(event.channel.id.to_s)
          end
        end
      end
      event.message.delete
      command_log('buy', event.user.name)
      nil
    end
  end
end
