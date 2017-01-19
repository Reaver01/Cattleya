module Commands
	module Inventory
		extend Discordrb::Commands::CommandContainer
		command(
				:inventory,
				description: "Sends a PM with your current inventory.",
				useage: "inventory"
		) do |event|
			BOT.user(event.user.id.to_s).pm.send_embed '', inventory(event.user.id.to_s, event.user.name.to_s)
			command_log("inventory", event.user.name)
			nil
		end
	end
end
