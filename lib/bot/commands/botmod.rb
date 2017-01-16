module Commands
	module Botmod
		extend Discordrb::Commands::CommandContainer
		command(
				:botmod,
				description: "Adds mod permissions to bot.",
				useage: "botmod <@name> <level> <force>",
				permission_level: 800,
				help_available: false,
				min_args: 1,
				max_args: 4,
				permission_message: "I'm sorry Dave, I cannot do that.",
		) do |event, uname, level=1, force="no"|
			del = "no"
			if level == "delete"
				del = "yes"
			end
			level = level.to_i
			permissions = Hash.new
			permissions = loadPERM(permissions,"botfiles/permissions.json")
			if $bot.parse_mention(uname) !=nil
				userid = $bot.parse_mention(uname).id
				if permissions.has_key?(userid.to_s)
					event.respond "User permissions found... Updating permissions."
					curlevel = permissions[userid.to_s]['lvl']
					event.respond "Current permission level: #{curlevel}"
					if [800, 999].include? curlevel
						if del == "yes"
							if force == "yes"
								event.respond "Force deleting user's permissions"
								permissions = permissions.without(userid)
							else
								event.respond "You must force deletion of admin or botmaster"
							end
						else
							if force == "yes"
								event.respond "Forcing permission change to lower level."
								permissions[userid.to_s]['lvl'] = level
							end
							if force == "no"
								event.respond "User permissions level is admin or higher, you must force permissions change to set lower."
							end
						end
					else
						if del == "yes"
							event.respond "Deleting user's permissions"
							permissions = permissions.without(userid.to_s)
						else
							event.respond "Changing user's permissions"
							permissions[userid.to_s]['lvl'] = level
						end
					end
				else
					event.respond "User permissions not found... Adding permissions."
					permissions[userid.to_s] = {'id'=>userid, 'lvl'=>level}
				end
				File.open("botfiles/permissions.json", 'w') { |f| f.write permissions.to_json }
				permissions.each do |key, value|
					$bot.set_user_permission(permissions[key]['id'], permissions[key]['lvl'])
				end
			else
				if uname == "check"
					event << permissions
				else
					event.respond "Invalid user."
				end
			end
			puts "[#{event.timestamp.strftime("%d %a %y | %H:%M:%S")}] #{event.user.name}: CMD: botmod"
			nil
		end
	end
end
