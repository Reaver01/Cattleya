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

def invItem(iIndex, iNum)
	e = Discordrb::Webhooks::Embed.new
	e.author = {
		name: $items[iIndex.to_i]['name']
	}
	e.color = "%06x" % (rand * 0xffffff)
	e.thumbnail = { url: "http://monsterhunteronline.in/images/item/#{$items[iIndex.to_i]['image']}.png"}
	e.description = "You have: #{iNum}"
	e
end