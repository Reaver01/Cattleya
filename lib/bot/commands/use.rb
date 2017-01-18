module Commands
	module Use
		extend Discordrb::Commands::CommandContainer
		command(
				:use,
				description: "Use an item on somebody or monster",
				useage: "use <item> <user>"
		) do |event, *item|
			user_name = item[-1]
			items_indexed = Hash[$items.map.with_index.to_a]
			used_item = -1
			if BOT.parse_mention(user_name) !=nil
				#throw things at somebody
				item = item.first item.size - 1
				item = item.join(' ').titleize
				threw = false
				x = 0
				begin
					if $items[x]['name'] == item
						threw = true
						used_item = items_indexed[$items[x]].to_s
						used_item_index = x
					end
					x += 1
				end while x < $items.length
				if threw
					if $players[event.user.id.to_s]['inv'].has_key?(used_item)
						if $items[used_item_index]['throw']
							event.respond "**#{item}s** must be thrown!"
						else
							event.respond "**#{event.user.name}** used a **#{item}** on #{user_name}!"
							$players[event.user.id.to_s]['inv'][used_item] -= 1
						end
						if $players[event.user.id.to_s]['inv'][used_item] < 1
							$players[event.user.id.to_s]['inv'] = $players[event.user.id.to_s]['inv'].without(used_item)
						end
					else
						event.respond "**#{event.user.name}** doesn't have any **#{item}s** to use!"
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
						used_item = items_indexed[$items[x]].to_s
						used_item_index = x
					end
					x += 1
				end while x < $items.length
				if threw
					if $players[event.user.id.to_s]['inv'].has_key?(used_item)
						if $items[used_item_index]['throw']
							event.respond "**#{item}s** must be thrown!"
						else
							event.respond "**#{event.user.name}** used a **#{item}**!"
							$players[event.user.id.to_s]['inv'][used_item] -= 1
						end
						if $players[event.user.id.to_s]['inv'][used_item] < 1
							$players[event.user.id.to_s]['inv'] = $players[event.user.id.to_s]['inv'].without(used_item)
						end
						if $current_unstable.has_key?(event.channel.id.to_s)
							if item == 'Shock Trap'
								if ['shock', 'both'].include? $current_unstable[event.channel.id.to_s]['trap']
									$current_unstable[event.channel.id.to_s]['intrap'] = true
									$current_unstable[event.channel.id.to_s]['traptime'] = Time.now
									event.respond "The #{$current_unstable[event.channel.id.to_s]['name']} has been trapped!"
								else
									event.respond "The #{$current_unstable[event.channel.id.to_s]['name']} can't be trapped by this type of trap!"
								end
							end
							if item == 'Pitfall Trap'
								if ['pitfall', 'both'].include? $current_unstable[event.channel.id.to_s]['trap']
									$current_unstable[event.channel.id.to_s]['intrap'] = true
									$current_unstable[event.channel.id.to_s]['traptime'] = Time.now
									event.respond "The #{$current_unstable[event.channel.id.to_s]['name']} has been trapped!"
								else
									event.respond "The #{$current_unstable[event.channel.id.to_s]['name']} can't be trapped by this type of trap!"
								end
							end
						end
					else
						event.respond "**#{event.user.name}** doesn't have any **#{item}s** to use!"
					end
				end
			end
			puts "[#{event.timestamp.strftime("%d %a %y | %H:%M:%S")}] #{event.user.name}: CMD: use"
			nil
		end
	end
end
