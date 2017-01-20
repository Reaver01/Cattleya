module Commands
	module MonsterInfo
		extend Discordrb::Commands::CommandContainer
		command(
				:minfo,
				description: "Responds with monster info",
				useage: "minfo"
		) do |event|
			if $current_unstable.has_key?(event.channel.id.to_s)
				begin
					event.channel.send_embed '', monster($current_unstable[event.channel.id.to_s])
				rescue
					mute_log(event.channel.id.to_s)
				end
			else
				begin
					event.respond "There isn't a monster in this channel right now."
				rescue
					mute_log(event.user.id.to_s)
				end
			end
			command_log("minfo", event.user.name)
			nil
		end
	end
end