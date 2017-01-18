module Commands
	module Use
		extend Discordrb::Commands::CommandContainer
		command(
				:use,
				description: "Use an item",
				useage: "use <item> <user>"
		) do |event, *item|
			uname = item[-1]
			itemsindexed = Hash[$items.map.with_index.to_a]
			useditem = -1
			if BOT.parse_mention(uname) !=nil
				#throw things at somebody
				item = item.first item.size - 1
				item = item.join(' ').titleize
				threw = false
				x = 0
				begin
					if $items[x]['name'] == item
						threw = true
						useditem = itemsindexed[$items[x]].to_s
						thrownindex = x
					end
					x += 1
				end while x < $items.length
				if threw
					if $players[event.user.id.to_s]['inv'].has_key?(useditem)
						if $items[thrownindex]['throw']
							event.respond "**#{item}s** must be thrown!"
						else
							event.respond "**#{event.user.name}** used a **#{item}** on #{uname}!"
							$players[event.user.id.to_s]['inv'][useditem] -= 1
						end
						if $players[event.user.id.to_s]['inv'][useditem] < 1
							$players[event.user.id.to_s]['inv'] = $players[event.user.id.to_s]['inv'].without(useditem)
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
						useditem = itemsindexed[$items[x]].to_s
						thrownindex = x
					end
					x += 1
				end while x < $items.length
				if threw
					if $players[event.user.id.to_s]['inv'].has_key?(useditem)
						if $items[thrownindex]['throw']
							event.respond "**#{item}s** must be thrown!"
						else
							event.respond "**#{event.user.name}** used a **#{item}**!"
							$players[event.user.id.to_s]['inv'][useditem] -= 1
						end
						if $players[event.user.id.to_s]['inv'][useditem] < 1
							$players[event.user.id.to_s]['inv'] = $players[event.user.id.to_s]['inv'].without(useditem)
						end
						if $current_unstable.has_key?(event.channel.id.to_s)
							if useditem == 'Shock Trap'
								if ['shock', 'both'].include? $current_unstable[event.channel.id.to_s]['trap']
									$current_unstable[event.channel.id.to_s]['intrap'] = true
									$current_unstable[event.channel.id.to_s]['traptime'] = Time.now
									event.respond "The #{$current_unstable[event.channel.id.to_s]['name']} has been trapped!"
								else
									event.respond "The #{$current_unstable[event.channel.id.to_s]['name']} can't be trapped by this type of trap!"
								end
							end
							if useditem == 'Pitfall Trap'
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
