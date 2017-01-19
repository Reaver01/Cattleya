module Commands
	module Throw
		extend Discordrb::Commands::CommandContainer
		command(
				:throw,
				description: "Throws something at somebody",
				useage: "throws <item> <user>"
		) do |event, *item|
			user_name = item[-1]
			items_indexed = Hash[$items.map.with_index.to_a]
			thrown_item = -1
			if BOT.parse_mention(user_name) !=nil
				#throw things at somebody
				item = item.first item.size - 1
				item = item.join(' ').titleize
				threw = false
				x = 0
				begin
					if $items[x]['name'] == item
						threw = true
						thrown_item = items_indexed[$items[x]].to_s
						thrown_item_index = x
					end
					x += 1
				end while x < $items.length
				if threw
					if $players[event.user.id.to_s]['inv'].has_key?(thrown_item)
						if $items[thrown_item_index]['throw']
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
					if $items[x]['name'] == item
						threw = true
						thrown_item = items_indexed[$items[x]].to_s
						thrown_item_index = x
					end
					x += 1
				end while x < $items.length
				if threw
					if $players[event.user.id.to_s]['inv'].has_key?(thrown_item)
						if $items[thrown_item_index]['throw']
							event.respond "**#{event.user.name}** threw a **#{item}**!"
							$players[event.user.id.to_s]['inv'][thrown_item] -= 1
						else
							event.respond "You can't throw **#{item}s**!"
						end
						if $players[event.user.id.to_s]['inv'][thrown_item] < 1
							$players[event.user.id.to_s]['inv'] = $players[event.user.id.to_s]['inv'].without(thrown_item)
						end
						if $current_unstable.has_key?(event.channel.id.to_s)
							damage_dealt = 0
							if item == 'Barrel Bomb S'
								if $current_unstable[event.channel.id.to_s].has_key?('intrap')
									if $current_unstable[event.channel.id.to_s]['intrap']
										chance_to_hit = 0
									else
										chance_to_hit = 2
									end
								else
									chance_to_hit = 2
								end
								if rand(0..chance_to_hit) == 0
									$current_unstable[event.channel.id.to_s]['hp'] -= 10
									event.respond "**#{event.user.name}** hit the **#{$current_unstable[event.channel.id.to_s]['name']}** with a **#{item}**!"
								else
									event.respond "**#{event.user.name}** missed!"
								end
							elsif item == 'Barrel Bomb L'
								if $current_unstable[event.channel.id.to_s].has_key?('intrap')
									if $current_unstable[event.channel.id.to_s]['intrap']
										chance_to_hit = 0
									else
										chance_to_hit = 1
									end
								else
									chance_to_hit = 1
								end
								if rand(0..chance_to_hit) == 0
									$current_unstable[event.channel.id.to_s]['hp'] -= 20
									event.respond "**#{event.user.name}** hit the **#{$current_unstable[event.channel.id.to_s]['name']}** with a **#{item}**!"
								else
									event.respond "**#{event.user.name}** missed!"
								end
							elsif item == 'Dynamite'
								if $current_unstable[event.channel.id.to_s].has_key?('intrap')
									if $current_unstable[event.channel.id.to_s]['intrap']
										chance_to_hit = 0
									else
										chance_to_hit = 3
									end
								else
									chance_to_hit = 3
								end
								if rand(0..chance_to_hit) == 0
									$current_unstable[event.channel.id.to_s]['hp'] -= 5
									event.respond "**#{event.user.name}** hit the **#{$current_unstable[event.channel.id.to_s]['name']}** with a **#{item}**!"
								else
									event.respond "**#{event.user.name}** missed!"
								end
							end
							unless damage_dealt == 0
								#stores the player that did damage in the unstable array with their damage dealt
								if $current_unstable[event.channel.id.to_s].has_key?('players')
									if $current_unstable[event.channel.id.to_s]['players'].has_key?(event.user.id.to_s)
										$current_unstable[event.channel.id.to_s]['players'][event.user.id.to_s] += damage_dealt
										$current_unstable[event.channel.id.to_s]['players2'][event.user.id.to_s] = event.user.name
									else
										$current_unstable[event.channel.id.to_s]['players'][event.user.id.to_s] = damage_dealt
										$current_unstable[event.channel.id.to_s]['players2'][event.user.id.to_s] = event.user.name
									end
								else
									$current_unstable[event.channel.id.to_s]['players'] = {"#{event.user.id}"=>damage_dealt}
									$current_unstable[event.channel.id.to_s]['players2'] = {"#{event.user.id}"=>event.user.name}
								end
							end
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
