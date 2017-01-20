module Commands
	module Info
		extend Discordrb::Commands::CommandContainer
		command(
				:info,
				bucket: :info,
				description: "Responds with player info",
				useage: "info"
		) do |event, mention|
			if BOT.parse_mention(mention) !=nil
				user_id = BOT.parse_mention(mention).id.to_s
				user_name = BOT.parse_mention(mention).name.to_s
				avatar = BOT.parse_mention(mention).avatar_url.to_s
			else
				user_id = event.user.id.to_s
				user_name = event.user.name.to_s
				avatar = event.user.avatar_url.to_s
			end
			event.channel.send_embed '', user_info(user_id, user_name, avatar)
			command_log("info", event.user.name)
			nil
		end
	end
end
