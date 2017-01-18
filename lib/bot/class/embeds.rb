def Embed(e_name, e_color, e_desc)
  Discordrb::Webhooks::Embed.new(
    author: { name: e_name, icon_url: e_icon },
    color: e_color,
    description: e_desc,
    timestamp: Time.now
  )
end

def EmbedWithIcon(e_name, e_icon, e_color, e_desc)
  Discordrb::Webhooks::Embed.new(
    author: { name: e_name, icon_url: e_icon },
    color: e_color,
    description: e_desc,
    timestamp: Time.now
  )
end

def EmbedWithThumbnail(e_name, e_color, e_thumb, e_desc)
  Discordrb::Webhooks::Embed.new(
    author: { name: e_name },
    color: e_color,
    thumbnail: { url: e_thumb }
    description: e_desc,
    timestamp: Time.now
  )
end

def EmbedWithIconAndThumbnail(e_name, e_icon e_color, e_thumb, e_desc)
  Discordrb::Webhooks::Embed.new(
    author: { name: e_name, icon_url: e_icon },
    color: e_color,
    thumbnail: { url: e_thumb }
    description: e_desc,
    timestamp: Time.now
  )
end

def inventory(id, user_name)
	desc = "**Zenny:** #{PLAYERS[id]['zenny']}\n\n"
	PLAYERS[id]['inv'].each do |key, item|
		desc += "**#{ITEMS[key.to_i]['name']}:** #{item.to_i}\n"
	end
	EmbedWithIcon("Here is your inventory #{user_name}!", BOT.profile.avatar_url, "%06x" % (rand * 0xffffff), desc)
end

def new_items(items, user_name)
	desc = ""
	items.each do |item|
		desc += "**#{ITEMS[item]['name']}**\n"
	end
	EmbedWithIcon("Here are the new items you recieved #{user_name}!", BOT.profile.avatar_url, "%06x" % (rand * 0xffffff), desc)
end

def userInfo(id, user_name, avatar)
	invnum = 0
	PLAYERS[id]['inv'].each do |key, item|
		invnum += item.to_i
	end
	EmbedWithIcon("This is info all about #{user_name}!", avatar, "%06x" % (rand * 0xffffff), "**Level:** #{PLAYERS[id]['level']}\n**HR:** #{PLAYERS[id]['hr']}\n**XP:** #{PLAYERS[id]['xp']}\n**Zenny:** #{PLAYERS[id]['zenny']}\n**Inventory:** #{invnum} items")
end

def NewMonster(arr)
	EmbedWithThumbnail(arr['name'], arr['color'], "http://monsterhunteronline.in/monsters/images/#{arr['icon']}.png", "Good luck!")
end

def monster(arr)
	is_angry = "No"
	is_trapped = "No"
	if arr.has_key?('intrap')
		if arr['intrap']
			is_trapped = "Yes"
		else
			is_trapped = "No"
		end
	end
	if arr.has_key?('angry')
		if arr['angry']
			is_angry = "Yes"
		else
			is_angry = "No"
		end
	end
	EmbedWithThumbnail(arr['name'], arr['color'], "http://monsterhunteronline.in/monsters/images/#{arr['icon']}.png", "Angry: #{is_angry}\nIn Trap: #{is_trapped}")
end

def HuntEnd(arr)
	desc = ''
	players = arr['players'].sort_by {|k,v| v}.reverse.to_h
	players.each do |k,v|
		desc += "**#{arr['players2'][k]}:** #{v}\n"
		if v > 50 + PLAYERS[k]['hr']
			PLAYERS[k]['hr'] += 1
		end
	end
	EmbedWithIconAndThumbnail("#{arr['name']}", "http://monsterhunteronline.in/monsters/images/#{arr['icon']}.png" arr['color'], "http://i.imgur.com/0MskAc1.png", desc.chomp("\n"))
end

def shop(arr)
	desc = ''
	x = 1
	arr.each do |k,v|
		desc += "**#{x}. #{k['name']}:** #{k['price']}\n"
		x += 1
	end
	Embed("Here is the shop listing!", "%06x" % (rand * 0xffffff), desc.chomp("\n"))
end