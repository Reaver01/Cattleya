module Commands
	module Inventory
		extend Discordrb::Commands::CommandContainer
		command(
				:inventory,
				description: "Displays your inventory",
				useage: "inventory"
		) do |event|
			$players[event.user.id.to_s]['inv'].each do |key, item|
				$bot.user(event.user.id.to_s).pm.send_embed '', invItem(key.to_i, item.to_i)
			end
			puts "[#{event.timestamp.strftime("%d %a %y | %H:%M:%S")}] #{event.user.name}: CMD: inventory"
			nil
		end
	end
end
