module Commands
	module Ping
		extend Discordrb::Commands::CommandContainer
		command(
				:ping,
				description: "Responds with response time",
				useage: "ping"
		) do |event|
			begin
				event.respond "Pong! : #{((Time.now - event.timestamp) * 1000).to_i}ms"
			rescue
				mute_log(event.channel.id.to_s)
			end
			command_log("ping", event.user.name)
			nil
		end
	end
end
