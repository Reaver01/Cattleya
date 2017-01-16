module Commands
	module Unstable
		extend Discordrb::Commands::CommandContainer
		command(
				:unstable,
				description: "Manage Daily reset subscription for channel.",
				usage: "unstable",
				help_available: true
		) do |event|
			isadmin = false
			event.user.roles.each do |x|
				if x.permissions.administrator
					isadmin = true
				end
			end
			if isadmin
				if $unstable.key?(event.channel.id.to_s)
					if $unstable[event.channel.id.to_s]
						$unstable[event.channel.id.to_s] = false
						event.respond "Unstable has been toggled off for this channel. Monsters will no longer appear."
					else
						$unstable[event.channel.id.to_s] = true
						event.respond "Unstable has been toggled on for this channel. Monsters will appear in this channel."
					end
				else
					$unstable[event.channel.id.to_s] = true
					event.respond "Unstable has been toggled on for this channel. Monsters will appear in this channel."
				end
				File.open('botfiles/unstable.json', 'w') { |f| f.write $unstable.to_json }
			else
				event.respond "Only an admin can toggle unstable on a channel"
			end
			puts "#{event.timestamp}: #{event.user.name}: CMD: unstable"
			nil
		end
	end
end
