module Commands
	module Buy
		extend Discordrb::Commands::CommandContainer
		command(
				:buy,
				bucket: :item_use,
				description: "Buys an item from the shop",
				useage: "buy",
				min_args: 1,
				max_args: 2
		) do |event, option_number, amount=1|
			if amount.to_i < 1
				amount = 1
			end
			amount = amount.to_i.round
			option_number = option_number.to_i.round
			unless option_number < 1 || option_number > $items.length - 1
				if $players.has_key?(event.user.id.to_s)
					if $players[event.user.id.to_s]['zenny'].to_i < ($items[option_number-1]['price'].to_i * amount.to_i)
						begin
							event.respond "You don't have enough Zenny to purchase #{amount} #{$items[option_number-1]['name']}"
						rescue
							mute_log(event.channel.id.to_s)
						end
					else
						$players[event.user.id.to_s]['zenny'] -= $items[option_number-1]['price'] * amount
						if $players[event.user.id.to_s]['inv'].has_key?("#{option_number-1}")
							$players[event.user.id.to_s]['inv']["#{option_number-1}"] += 1 * amount
						else
							$players[event.user.id.to_s]['inv']["#{option_number-1}"] = 1 * amount
						end
						begin
							event.respond "**#{event.user.name}** purchased **#{amount} #{$items[option_number-1]['name']}**"
						rescue
							mute_log(event.channel.id.to_s)
						end
					end
				end
			else
				begin
					event.respond "That is not a valid option"
				rescue
					mute_log(event.channel.id.to_s)
				end
			end
			command_log("buy", event.user.name)
			nil
		end
	end
end
