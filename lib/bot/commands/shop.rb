module Commands
	module Shop
		extend Discordrb::Commands::CommandContainer
		command(
				:shop,
				description: "Displays shop listing",
				useage: "shop"
		) do |event|
			$bot.user(event.user.id.to_s).pm.send_embed '', shop($items)
			puts "[#{event.timestamp.strftime("%d %a %y | %H:%M:%S")}] #{event.user.name}: CMD: shop"
			nil
		end
	end
end
