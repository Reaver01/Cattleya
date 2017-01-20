module Commands
	module Eval
		extend Discordrb::Commands::CommandContainer
		command(
				:eval,
				description: "Evaluates code.",
				useage: "eval <code>",
				help_available: false,
				permission_level: 800
		) do |event, *code|
			command_log("eval", event.user.name)
			begin
				eval code.join(' ')
			rescue StandardError => e
				begin
					event.respond(e.to_s)
				rescue
					mute_log(event.channel.id.to_s)
				end
			end
		end
	end
end
