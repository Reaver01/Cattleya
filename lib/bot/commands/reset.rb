module Commands
	module Reset
		extend Discordrb::Commands::CommandContainer
		command(
				:reset,
				bucket: :reset,
				description: "Resets player back to 0",
				useage: "reset"
		) do |event|
			if $players.key?(event.user.id.to_s)
				if $players[event.user.id.to_s].key?('messages')
					messages = $players[event.user.id.to_s]['messages']
				else
					messages = false
				end
				$players[event.user.id.to_s] = {'xp'=>0, 'level'=>0, 'hr'=>0, 'zenny'=>100, 'time'=>event.timestamp, 'inv'=>{'0'=>1}, 'messages'=>messages}
				begin
					event.respond "**#{event.user.name}** has been reset."
				rescue
					mute_log(event.channel.id.to_s)
				end
			end
			command_log("reset", event.user.name)
			nil
		end
	end
end
