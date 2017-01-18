def embed(e_name, e_desc)
	Discordrb::Webhooks::Embed.new(
		author: { name: e_name },
		color: rand(0xffffff),
		description: e_desc,
		timestamp: Time.now
	)
end

def inventory(id, user_name)
	desc = "**Zenny:** #{$players[id]['zenny']}\n\n"
	$players[id]['inv'].each do |key, item|
		desc += "**#{$items[key.to_i]['name']}:** #{item.to_i}\n"
	end
	e = embed("Here is your inventory #{user_name}!", desc)
	e.author[:icon_url] = BOT.profile.avatar_url
	e
end

def new_items(items, user_name)
	desc = ""
	items.each do |item|
		desc += "**#{$items[item]['name']}**\n"
	end
	e = embed("Here are the new items you recieved #{user_name}!", desc)
	e.author[:icon_url] = BOT.profile.avatar_url
	e
end

def user_info(id, user_name, avatar)
	invnum = 0
	$players[id]['inv'].each do |key, item|
		invnum += item.to_i
	end
	e = embed("This is info all about #{user_name}!", "**Level:** #{$players[id]['level']}\n**HR:** #{$players[id]['hr']}\n**XP:** #{$players[id]['xp']}\n**Zenny:** #{$players[id]['zenny']}\n**Inventory:** #{invnum} items")
	e.author[:icon_url] = avatar
	e
end

def new_monster(arr)
	e = embed(arr['name'], "Good luck!")
	e.color = arr['color']
	e.thumbnail = { url: "http://monsterhunteronline.in/monsters/images/#{arr['icon']}.png" }
	e
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
	e = embed(arr['name'], "Angry: #{is_angry}\nIn Trap: #{is_trapped}")
	e.color = arr['color']
	e.thumbnail = { url: "http://monsterhunteronline.in/monsters/images/#{arr['icon']}.png" }
	e
end

def hunt_end(arr)
	desc = ''
	players = arr['players'].sort_by {|k,v| v}.reverse.to_h
	players.each do |k,v|
		desc += "**#{arr['players2'][k]}:** #{v}\n"
		if v > 50 + $players[k]['hr']
			$players[k]['hr'] += 1
		end
	end
	e = embed("#{arr['name']}", desc.chomp("\n"))
	e.author[:icon_url] = "http://monsterhunteronline.in/monsters/images/#{arr['icon']}.png"
	e.color = arr['color']
	e.thumbnail = { url: "http://i.imgur.com/0MskAc1.png" }
	e
end

def shop(arr)
	desc = ''
	x = 1
	arr.each do |k,v|
		desc += "**#{x}. #{k['name']}:** #{k['price']}\n"
		x += 1
	end
	embed("Here is the shop listing!", desc.chomp("\n"))
end