module Commands
	module MonsterInfo
		extend Discordrb::Commands::CommandContainer
		command(
				:minfo,
				description: "Responds with monster info",
				useage: "minfo"
		) do |event|
			if $current_unstable.has_key?(event.channel.id.to_s)
				event.channel.send_embed '', monster($current_unstable[event.channel.id.to_s])
			else
				event.respond "There isn't a monster in this channel right now."
			end
			command_log("minfo", event.user.name)
			nil
		end
	end
end
