module Commands
	module Hosting
		extend Discordrb::Commands::CommandContainer
		command(
				:hosting,
				description: "Responds with hosting info",
				useage: "hosting"
		) do |event|
			event.respond "This bot is hosted on DigitalOcean Servers.\nHost your own bot/app with $10 credit using my referral link: <https://m.do.co/c/71922c060e60>\nThis will help me keep Felyne live as long as you keep using their hosting after the first $10 credit :D"
			puts "[#{event.timestamp.strftime("%d %a %y | %H:%M:%S")}] #{event.user.name}: CMD: hosting"
			nil
		end
	end
end
