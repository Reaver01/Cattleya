module Commands
	module Throw
		extend Discordrb::Commands::CommandContainer
		command(
				:throw,
				description: "Throws something at somebody",
				useage: "throws <item> <user>"
		) do |event, *item|
			uname = item[-1]
			itemsindexed = Hash[$items.map.with_index.to_a]
			thrownitem = -1
			if $bot.parse_mention(uname) !=nil
				#throw things at somebody
				item = item.first item.size - 1
				item = item.join(' ').titleize
				threw = false
				x = 0
				begin
					if $items[x]['name'] == item
						threw = true
						thrownitem = itemsindexed[$items[x]].to_s
						thrownindex = x
					end
					x += 1
				end while x < $items.length
				if threw
					if $players[event.user.id.to_s]['inv'].has_key?(thrownitem)
						if $items[thrownindex]['throw']
							event.respond "**#{event.user.name}** threw a **#{item}** at #{uname}!"
							$players[event.user.id.to_s]['inv'][thrownitem] -= 1
						else
							event.respond "You can't throw **#{item}s**!"
						end
						if $players[event.user.id.to_s]['inv'][thrownitem] < 1
							$players[event.user.id.to_s]['inv'] = $players[event.user.id.to_s]['inv'].without(thrownitem)
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
					if $items[x]['name'] == item
						threw = true
						thrownitem = itemsindexed[$items[x]].to_s
						thrownindex = x
					end
					x += 1
				end while x < $items.length
				if threw
					if $players[event.user.id.to_s]['inv'].has_key?(thrownitem)
						if $items[thrownindex]['throw']
							event.respond "**#{event.user.name}** threw a **#{item}**!"
							$players[event.user.id.to_s]['inv'][thrownitem] -= 1
						else
							event.respond "You can't throw **#{item}s**!"
						end
						if $players[event.user.id.to_s]['inv'][thrownitem] < 1
							$players[event.user.id.to_s]['inv'] = $players[event.user.id.to_s]['inv'].without(thrownitem)
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
