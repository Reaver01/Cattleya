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

def inventory(id, uname)
	desc = "**Zenny:** #{$players[id]['zenny']}\n\n"
	$players[id]['inv'].each do |key, item|
		desc += "**#{$items[key.to_i]['name']}:** #{item.to_i}\n"
	end
	e = Discordrb::Webhooks::Embed.new
	e.author = {
		name: "Here is your inventory #{uname}!",
		icon_url: $bot.profile.avatar_url
	}
	e.color = "%06x" % (rand * 0xffffff)
	e.description = desc
	e
end

def newItems(items, uname)
	desc = ""
	items.each do |item|
		desc += "**#{$items[item]['name']}**\n"
	end
	e = Discordrb::Webhooks::Embed.new
	e.author = {
		name: "Here are the new items you recieved #{uname}!",
		icon_url: $bot.profile.avatar_url
	}
	e.color = "%06x" % (rand * 0xffffff)
	e.description = desc
	e
end

def userInfo(id, uname, avatar)
	invnum = 0
	$players[id]['inv'].each do |key, item|
		invnum += item.to_i
	end
	e = Discordrb::Webhooks::Embed.new
	e.author = {
		name: "This is info all about #{uname}!",
		icon_url: avatar
	}
	e.color = "%06x" % (rand * 0xffffff)
	e.description = "**Level:** #{$players[id]['level']}\n**HR:** #{$players[id]['hr']}\n**XP:** #{$players[id]['xp']}\n**Zenny:** #{$players[id]['zenny']}\n**Inventory:** #{invnum} items"
	e
end

def newMonster(arr)
	e = Discordrb::Webhooks::Embed.new
	e.author = {
		name: arr['name']
	}
	e.color = arr['color']
	e.thumbnail = { url: "http://monsterhunteronline.in/monsters/images/#{arr['icon']}.png" }
	e.description = "Good luck!"
	e
end

def monster(arr)
	anger = "No"
	trap = "No"
	if arr.has_key?('intrap')
		if arr['intrap']
			trap = "Yes"
		else
			trap = "No"
		end
	end
	if arr.has_key?('angry')
		if arr['angry']
			anger = "Yes"
		else
			anger = "No"
		end
	end
	e = Discordrb::Webhooks::Embed.new
	e.author = {
		name: arr['name']
	}
	e.color = arr['color']
	e.thumbnail = { url: "http://monsterhunteronline.in/monsters/images/#{arr['icon']}.png" }
	e.description = "Angry: #{anger}\nIn Trap: #{trap}"
	e
end

def huntEnd(arr)
	desc = ''
	players = arr['players'].sort_by {|k,v| v}.reverse.to_h
	players.each do |k,v|
		desc += "**#{arr['players2'][k]}:** #{v}\n"
		if v > 50 + $players[k]['hr']
			$players[k]['hr'] += 1
		end
	end
	e = Discordrb::Webhooks::Embed.new
	e.author = {
		name: "#{arr['name']}",
		icon_url: "http://monsterhunteronline.in/monsters/images/#{arr['icon']}.png"
	}
	e.color = arr['color']
	e.thumbnail = { url: "http://i.imgur.com/0MskAc1.png" }
	e.description = desc.chomp("\n")
	e
end

def shop(arr)
	desc = ''
	x = 1
	arr.each do |k,v|
		desc += "**#{x}. #{k['name']}:** #{k['price']}\n"
		x += 1
	end
	e = Discordrb::Webhooks::Embed.new
	e.author = {
		name: "Here is the shop listing!"
	}
	e.color = "%06x" % (rand * 0xffffff)
	e.description = desc.chomp("\n")
	e.footer = "use >buy # to buy an item!"
	e
end