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
		) do |event, mention, level=1, force="no"|
			delete_permission = "no"
			if level == "delete_permissionete"
				delete_permission = "yes"
			end
			level = level.to_i
			permissions = Hash.new
			permissions = LoadPermissions(permissions,"botfiles/permissions.json")
			if BOT.parse_mention(mention) !=nil
				user_id = BOT.parse_mention(mention).id
				if permissions.has_key?(user_id.to_s)
					event.respond "User permissions found... Updating permissions."
					current_permission_level = permissions[user_id.to_s]['lvl']
					event.respond "Current permission level: #{current_permission_level}"
					if [800, 999].include? current_permission_level
						if delete_permission == "yes"
							if force == "yes"
								event.respond "Force delete_permissioneting user's permissions"
								permissions = permissions.without(user_id)
							else
								event.respond "You must force delete_permissionetion of admin or botmaster"
							end
						else
							if force == "yes"
								event.respond "Forcing permission change to lower level."
								permissions[user_id.to_s]['lvl'] = level
							end
							if force == "no"
								event.respond "User permissions level is admin or higher, you must force permissions change to set lower."
							end
						end
					else
						if delete_permission == "yes"
							event.respond "delete_permissioneting user's permissions"
							permissions = permissions.without(user_id.to_s)
						else
							event.respond "Changing user's permissions"
							permissions[user_id.to_s]['lvl'] = level
						end
					end
				else
					event.respond "User permissions not found... Adding permissions."
					permissions[user_id.to_s] = {'id'=>user_id, 'lvl'=>level}
				end
				File.open("botfiles/permissions.json", 'w') { |f| f.write permissions.to_json }
				permissions.each do |key, value|
					BOT.set_user_permission(permissions[key]['id'], permissions[key]['lvl'])
				end
			else
				if mention == "check"
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
