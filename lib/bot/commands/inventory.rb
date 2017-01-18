module Commands
	module Inventory
		extend Discordrb::Commands::CommandContainer
		command(
				:inventory,
				description: "Sends a PM with your current inventory.",
				useage: "inventory"
		) do |event|
			BOT.user(event.user.id.to_s).pm.send_embed '', inventory(event.user.id.to_s, event.user.name.to_s)
			puts "[#{event.timestamp.strftime("%d %a %y | %H:%M:%S")}] #{event.user.name}: CMD: inventory"
			nil
		end
	end
end
