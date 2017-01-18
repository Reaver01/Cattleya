module Commands
	module Info
		extend Discordrb::Commands::CommandContainer
		command(
				:info,
				description: "responds with player info",
				useage: "info"
		) do |event, uname|
			if $bot.parse_mention(uname) !=nil
				userid = $bot.parse_mention(uname).id.to_s
				username = $bot.parse_mention(uname).name.to_s
				avatar = $bot.parse_mention(uname).avatar_url
			else
				userid = event.user.id.to_s
				username = event.user.name.to_s
				avatar = event.user.avatar_url.to_s
			end
			event.channel.send_embed '', userInfo(userid, username, avatar)
			puts "[#{event.timestamp.strftime("%d %a %y | %H:%M:%S")}] #{event.user.name}: CMD: info"
			nil
		end
	end
end
