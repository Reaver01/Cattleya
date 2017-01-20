module Commands
	module Unstable
		extend Discordrb::Commands::CommandContainer
		command(
				:unstable,
				description: "Toggle $unstable status for the current channel.",
				usage: "unstable",
				help_available: true
		) do |event|
			if event.user.can_manage_channels?
				if $unstable.key?(event.channel.id.to_s)
					if $unstable[event.channel.id.to_s]
						$unstable[event.channel.id.to_s] = false
						begin
							event.respond "$unstable has been toggled off for this channel. Monsters will no longer appear."
						rescue
							mute_log(event.channel.id.to_s)
						end
					else
						$unstable[event.channel.id.to_s] = true
						begin
							event.respond "$unstable has been toggled on for this channel. Monsters will appear in this channel."
						rescue
							mute_log(event.channel.id.to_s)
						end
					end
				else
					$unstable[event.channel.id.to_s] = true
					begin
						event.respond "$unstable has been toggled on for this channel. Monsters will appear in this channel."
					rescue
						mute_log(event.channel.id.to_s)
					end
				end
				File.open('botfiles/unstable.json', 'w') { |f| f.write $unstable.to_json }
			else
				begin
					event.respond "Only an admin can toggle $unstable on a channel"
				rescue
					mute_log(event.channel.id.to_s)
				end
			end
			command_log("unstable", event.user.name)
			nil
		end
	end
end
