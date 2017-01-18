module Commands
	module Info
		extend Discordrb::Commands::CommandContainer
		command(
				:info,
				description: "Responds with player info",
				useage: "info"
		) do |event, mention|
			if BOT.parse_mention(mention) !=nil
				user_id = BOT.parse_mention(mention).id.to_s
				user_name = BOT.parse_mention(mention).name.to_s
				avatar = BOT.parse_mention(mention).avatar_url
			else
				user_id = event.user.id.to_s
				user_name = event.user.name.to_s
				avatar = event.user.avatar_url.to_s
			end
			event.channel.send_embed '', userInfo(user_id, user_name, avatar)
			puts "[#{event.timestamp.strftime("%d %a %y | %H:%M:%S")}] #{event.user.name}: CMD: info"
			nil
		end
	end
end
