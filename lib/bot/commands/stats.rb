module Commands
	module Stats
		extend Discordrb::Commands::CommandContainer
		command(
				:stats,
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
			event.channel.send_embed '', e
			command_log("stats", event.user.name)
			nil
		end
	end
end
