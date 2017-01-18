module Commands
	module Throw
		extend Discordrb::Commands::CommandContainer
		command(
				:throw,
				description: "Throws something at somebody",
				useage: "throws <item> <user>"
		) do |event, *item|
			user_name = item[-1]
			items_indexed = Hash[ITEMS.map.with_index.to_a]
			thrown_item = -1
			if BOT.parse_mention(user_name) !=nil
				#throw things at somebody
				item = item.first item.size - 1
				item = item.join(' ').titleize
				threw = false
				x = 0
				begin
					if ITEMS[x]['name'] == item
						threw = true
						thrown_item = items_indexed[ITEMS[x]].to_s
						thrown_item_index = x
					end
					x += 1
				end while x < ITEMS.length
				if threw
					if $players[event.user.id.to_s]['inv'].has_key?(thrown_item)
						if ITEMS[thrown_item_index]['throw']
							event.respond "**#{event.user.name}** threw a **#{item}** at #{user_name}!"
							$players[event.user.id.to_s]['inv'][thrown_item] -= 1
						else
							event.respond "You can't throw **#{item}s**!"
						end
						if $players[event.user.id.to_s]['inv'][thrown_item] < 1
							$players[event.user.id.to_s]['inv'] = $players[event.user.id.to_s]['inv'].without(thrown_item)
						end
					else
						event.respond "**#{event.user.name}** doesn't have any **#{item}s** to throw!"
					end
				end
			else
				#throw things at the ground
				item = item.join(' ').titleize
				threw = false
				x = 0
				begin
					if ITEMS[x]['name'] == item
						threw = true
						thrown_item = items_indexed[ITEMS[x]].to_s
						thrown_item_index = x
					end
					x += 1
				end while x < ITEMS.length
				if threw
					if $players[event.user.id.to_s]['inv'].has_key?(thrown_item)
						if ITEMS[thrown_item_index]['throw']
							event.respond "**#{event.user.name}** threw a **#{item}**!"
							$players[event.user.id.to_s]['inv'][thrown_item] -= 1
						else
							event.respond "You can't throw **#{item}s**!"
						end
						if $players[event.user.id.to_s]['inv'][thrown_item] < 1
							$players[event.user.id.to_s]['inv'] = $players[event.user.id.to_s]['inv'].without(thrown_item)
						end
					else
						event.respond "**#{event.user.name}** doesn't have any **#{item}s** to throw!"
					end
				end
			end
			puts "[#{event.timestamp.strftime("%d %a %y | %H:%M:%S")}] #{event.user.name}: CMD: throw"
			nil
		end
	end
end
