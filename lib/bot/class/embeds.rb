def embed(eName, eDesc)
	e = Discordrb::Webhooks::Embed.new
	e.author = {
		name: eName
	}
	e.color = "%06x" % (rand * 0xffffff)
	e.description = eDesc
	e.timestamp = Time.now
	e
end
