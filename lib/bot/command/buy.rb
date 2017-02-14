module Commands
  # Command Module
  module Buy
    extend Discordrb::Commands::CommandContainer
    command(
      [:buy, :b],
      bucket: :item_use,
      description: 'Buys an item from the shop',
      usage: 'buy',
      min_args: 1,
      max_args: 2
    ) do |event, option_number, amount = 1|
      user_id = event.user.id.to_s
      amount = 1 if amount.to_i < 1
      amount = amount.to_i.round
      option_number = option_number.to_i.round
      if option_number < 1 || option_number > ITEMS.length - 1
        begin
          m = 'That is not a valid option'
        rescue
          mute_log(event.channel.id.to_s)
        end
      elsif $players.key?(user_id)
        if $players[user_id]['zenny'].to_i < (ITEMS[option_number -
                                                        1]['price'].to_i *
                                                        amount.to_i)
          begin
            m = "You don't have enough Zenny to purchase #{amount} " \
                          "#{ITEMS[option_number - 1]['name']}"
          rescue
            mute_log(event.channel.id.to_s)
          end
        else
          $players[user_id]['zenny'] -= ITEMS[option_number - 1]['price'] *
                                        amount
          if $players[user_id]['inventory'].key?((option_number - 1).to_s)
            $players[user_id]['inventory'][(option_number - 1).to_s] += 1 * amount
          else
            $players[user_id]['inventory'][(option_number - 1).to_s] = 1 * amount
          end
          begin
            m = "**#{event.user.name}** purchased **#{amount} " \
                          "#{ITEMS[option_number - 1]['name']}**"
          rescue
            mute_log(event.channel.id.to_s)
          end
        end
      end
      event.message.delete unless event.message.channel.pm?
      command_log('buy', event.user.name)
      m
    end
  end
end
