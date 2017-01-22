module Commands
	module Throw
		extend Discordrb::Commands::CommandContainer
		command(
				:throw,
				bucket: :item_use,
				description: 'Throws something at somebody',
				useage: 'throw <item> <user>'
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
							begin
								event.respond "**#{event.user.name}** threw a **#{item}** at #{user_name}!"
							rescue
								mute_log(event.channel.id.to_s)
							end
							$players[event.user.id.to_s]['inv'][thrown_item] -= 1
						else
							begin
								event.respond "You can't throw **#{item}s**!"
							rescue
								mute_log(event.channel.id.to_s)
							end
						end
						if $players[event.user.id.to_s]['inv'][thrown_item] < 1
							$players[event.user.id.to_s]['inv'] = $players[event.user.id.to_s]['inv'].without(thrown_item)
						end
					else
						begin
							event.respond "**#{event.user.name}** doesn't have any **#{item}s** to throw!"
						rescue
							mute_log(event.channel.id.to_s)
						end
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
							begin
								event.respond "**#{event.user.name}** threw a **#{item}**!"
							rescue
								mute_log(event.channel.id.to_s)
							end
							$players[event.user.id.to_s]['inv'][thrown_item] -= 1
						else
							begin
								event.respond "You can't throw **#{item}s**!"
							rescue
								mute_log(event.channel.id.to_s)
							end
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
									damage_dealt = 20
									$current_unstable[event.channel.id.to_s]['hp'] -= damage_dealt
									begin
										event.respond "**#{event.user.name}** hit the **#{$current_unstable[event.channel.id.to_s]['name']}** with a **#{item}**!"
									rescue
										mute_log(event.channel.id.to_s)
									end
								else
									begin
										event.respond "**#{event.user.name}** missed!"
									rescue
										mute_log(event.channel.id.to_s)
									end
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
									damage_dealt = 40
									$current_unstable[event.channel.id.to_s]['hp'] -= damage_dealt
									begin
										event.respond "**#{event.user.name}** hit the **#{$current_unstable[event.channel.id.to_s]['name']}** with a **#{item}**!"
									rescue
										mute_log(event.channel.id.to_s)
									end
								else
									begin
										event.respond "**#{event.user.name}** missed!"
									rescue
										mute_log(event.channel.id.to_s)
									end
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
									damage_dealt = 15
									$current_unstable[event.channel.id.to_s]['hp'] -= damage_dealt
									begin
										event.respond "**#{event.user.name}** hit the **#{$current_unstable[event.channel.id.to_s]['name']}** with a **#{item}**!"
									rescue
										mute_log(event.channel.id.to_s)
									end
								else
									begin
										event.respond "**#{event.user.name}** missed!"
									rescue
										mute_log(event.channel.id.to_s)
									end
								end
							elsif item == 'Pickaxe'
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
									damage_dealt = 5
									$current_unstable[event.channel.id.to_s]['hp'] -= damage_dealt
									begin
										event.respond "**#{event.user.name}** hit the **#{$current_unstable[event.channel.id.to_s]['name']}** with a **#{item}**!"
									rescue
										mute_log(event.channel.id.to_s)
									end
								else
									begin
										event.respond "**#{event.user.name}** missed!"
									rescue
										mute_log(event.channel.id.to_s)
									end
								end
							elsif item == 'Dung Bomb'
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
									empty_channels = []
									$unstable.each do |key, value|
										if value
											unless $current_unstable.has_key?(key)
												empty_channels.push(key)
											end
										end
									end
									unless empty_channels.length == 0
										new_channel = empty_channels.sample
										$current_unstable[new_channel] = $current_unstable[event.channel.id.to_s]
										begin
											event.respond "**#{event.user.name}** hit the **#{$current_unstable[event.channel.id.to_s]['name']}** with a **#{item}**!"
										rescue
											mute_log(event.channel.id.to_s)
										end
										$current_unstable = $current_unstable.without(event.channel.id.to_s)		
										begin
											BOT.channel(new_channel).send_embed "A Monster has entered the channel!\nThis monster came from **#{event.channel.name}** via a Dung Bomb!", new_monster($current_unstable[new_channel])
											event.respond "The monster has moved to **#{BOT.channel(new_channel).name}**"
										rescue
											event.respond "**#{BOT.channel(new_channel).name}** has muted me and isn't allowed to spawn monsters."
											$current_unstable[event.channel.id.to_s] = $current_unstable[new_channel]
											$current_unstable = $current_unstable.without(new_channel)
											$unstable[new_channel.to_s] = false
											mute_log(new_channel.to_s)
										end
										File.open('botfiles/current_unstable.json', 'w') { |f| f.write $current_unstable.to_json }
									else
										event.respond "There are no channels for the monster to go!"
									end
								else
									begin
										event.respond "**#{event.user.name}** missed!"
									rescue
										mute_log(event.channel.id.to_s)
									end
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
						begin
							event.respond "**#{event.user.name}** doesn't have any **#{item}s** to throw!"
						rescue
							mute_log(event.channel.id.to_s)
						end
					end
				end
			end
			command_log('throw', event.user.name)
			nil
		end
	end
end
