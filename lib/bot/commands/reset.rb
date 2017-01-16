module Commands
	module Reset
		extend Discordrb::Commands::CommandContainer
		command(
				:reset,
				bucket: :delay10,
				description: "Resets player back to 0",
				useage: "reset"
		) do |event|
			if $players.key?(event.user.id.to_s)
				$players[event.user.id.to_s] = {'xp'=>0, 'level'=>0, 'hr'=>0, 'zenny'=>100, 'time'=>newtime, 'inv'=>{'0'=>1}}
				event.respond "**#{event.user.name}** has been reset."
			end
			puts "[#{event.timestamp.strftime("%d %a %y | %H:%M:%S")}] #{event.user.name}: CMD: reset"
			nil
		end
	end
end
