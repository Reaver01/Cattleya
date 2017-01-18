module Commands
	module MonsterInfo
		extend Discordrb::Commands::CommandContainer
		command(
				:minfo,
				description: "Responds with monster info",
				useage: "monster"
		) do |event|
			if CURRENT_UNSTABLE.has_key?(event.channel.id.to_s)
				event.channel.send_embed '', monster(CURRENT_UNSTABLE[event.channel.id.to_s])
			else
				event.respond "There isn't a monster in this channel right now."
			end
			puts "[#{event.timestamp.strftime("%d %a %y | %H:%M:%S")}] #{event.user.name}: CMD: monster"
			nil
		end
	end
end
