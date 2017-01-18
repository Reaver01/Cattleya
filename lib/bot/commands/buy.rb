module Commands
	module Buy
		extend Discordrb::Commands::CommandContainer
		command(
				:buy,
				description: "Buys an item from the shop",
				useage: "buy",
				min_args: 1,
				max_args: 2
		) do |event, option_number, amount=1|
			if amount.to_i < 1
				amount = 1
			end
			amount = amount.to_i.round
			option_number = option_number.to_i
			if $players.has_key?(event.user.id.to_s)
				if $players[event.user.id.to_s]['zenny'].to_i < (ITEMS[option_number-1]['price'].to_i * amount.to_i)
					event.respond "You don't have enough Zenny to purchase #{amount} #{ITEMS[option_number-1]['name']}"
				else
					$players[event.user.id.to_s]['zenny'] -= ITEMS[option_number-1]['price'] * amount
					if $players[event.user.id.to_s]['inv'].has_key?("#{option_number-1}")
						$players[event.user.id.to_s]['inv']["#{option_number-1}"] += 1 * amount
					else
						$players[event.user.id.to_s]['inv']["#{option_number-1}"] = 1 * amount
					end
					event.respond "**#{event.user.name}** purchased **#{amount} #{ITEMS[option_number-1]['name']}**"
				end
			end
			puts "[#{event.timestamp.strftime("%d %a %y | %H:%M:%S")}] #{event.user.name}: CMD: buy"
			nil
		end
	end
end
