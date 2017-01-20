module Commands
	module Stats
		extend Discordrb::Commands::CommandContainer
		command(
				:stats,
				bucket: :info,
				description: "Responds with bot stats",
				useage: "stats"
		) do |event|
			desc = "Commands used:\n"
			if $logs.has_key?('commands')
				$logs['commands'].each do |key, value|
					desc += "**#{key}:** #{value}\n"
				end
			end
			e = embed("Bot statistics:", desc.chomp("\n"))
			e
			begin
				event.channel.send_embed '', e
			rescue
				mute_log(event.channel.id.to_s)
			end
			command_log("stats", event.user.name)
			nil
		end
	end
end
