module Commands
	module Buy
		extend Discordrb::Commands::CommandContainer
		command(
				:buy,
				description: "Buys an item from the shop",
				useage: "buy",
				min_args: 1,
				max_args: 2
		) do |event, opt, num=1|
			if num < 1
				num = 1
			end
			num = num.to_i.round
			opt = opt.to_i
			if $players.has_key?(event.user.id.to_s)
				if $players[event.user.id.to_s]['zenny'].to_i < $items[opt-1]['price'].to_i * num.to_i
					event.respond "You don't have enough Zenny to purchase #{num} #{$items[opt-1]['name']}"
				else
					$players[event.user.id.to_s]['zenny'] -= $items[opt-1]['price'] * num
					if $players[event.user.id.to_s]['inv'].has_key?("#{opt-1}")
						$players[event.user.id.to_s]['inv']["#{opt-1}"] += 1 * num
					else
						$players[event.user.id.to_s]['inv']["#{opt-1}"] = 1 * num
					end
					event.respond "**#{event.user.name}** purchased **#{num} #{$items[opt-1]['name']}**"
				end
			end
			puts "[#{event.timestamp.strftime("%d %a %y | %H:%M:%S")}] #{event.user.name}: CMD: buy"
			nil
		end
	end
end
