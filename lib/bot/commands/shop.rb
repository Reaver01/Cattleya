module Commands
	module Shop
		extend Discordrb::Commands::CommandContainer
		command(
				:shop,
				description: "Displays shop listing",
				useage: "shop"
		) do |event|
			BOT.user(event.user.id.to_s).pm.send_embed '', shop($items)
			command_log("shop", event.user.name)
			nil
		end
	end
end
