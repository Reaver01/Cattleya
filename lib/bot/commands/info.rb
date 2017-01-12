module Commands
	module Info
		extend Discordrb::Commands::CommandContainer
		command(
				:info,
				description: "responds with player info",
				useage: "info"
		) do |event|
			event.channel.send_embed '', userInfo(event.user.id.to_s, event.user.name.to_s)
			puts "[#{event.timestamp.strftime("%d %a %y | %H:%M:%S")}] #{event.user.name}: CMD: info"
			nil
		end
	end
end
