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
    desc += "**#{ITEMS[key.to_i]['name']}:** #{item.to_i}\n"
  end
  e = embed("Here is your inventory #{user_name}!", desc)
  e.author[:icon_url] = BOT.profile.avatar_url
  e
end

def new_items(items, user_name)
  desc = ''
  items.each do |item|
    desc += "**#{ITEMS[item]['name']}**\n"
  end
  e = embed("Here are the new items you recieved #{user_name}!", desc)
  e.author[:icon_url] = BOT.profile.avatar_url
  e
end

def user_info(id, user_name, avatar)
  invnum = 0
  $players[id]['inv'].each do |_key, item|
    invnum += item.to_i
  end
  unless $players[id].key?('max_hp')
    new_hp = 500 + ($players[id]['level'] * 10)
    $players[id]['max_hp'] = new_hp
    $players[id]['current_hp'] = new_hp
  end
  e = embed(
    "This is info all about #{user_name}!",
    "**Level:** #{$players[id]['level']}\n**HR:** #{$players[id]['hr']}\n" \
    "**XP:** #{$players[id]['xp']}\n" \
    "**Current HP:** #{$players[id]['current_hp']}\n" \
    "**Zenny:** #{$players[id]['zenny']}\n" \
    "**Inventory:** #{invnum} items"
  )
  e.author[:icon_url] = avatar
  e
end

def new_monster(arr)
  e = embed(arr['name'], 'Good luck!')
  e.color = arr['color']
  e.thumbnail = {
    url: "http://monsterhunteronline.in/monsters/images/#{arr['icon']}.png"
  }
  e
end

def monster(arr)
  is_angry = 'No'
  is_trapped = 'No'
  if arr.key?('intrap')
    is_trapped = if arr['intrap']
                   'Yes'
                 else
                   'No'
                 end
  end
  if arr.key?('angry')
    is_angry = if arr['angry']
                 'Yes'
               else
                 'No'
               end
  end
  e = embed(arr['name'], "Angry: #{is_angry}\nIn Trap: #{is_trapped}")
  e.color = arr['color']
  e.thumbnail = {
    url: "http://monsterhunteronline.in/monsters/images/#{arr['icon']}.png"
  }
  e
end

def hunt_end(arr)
  desc = ''
  players = arr['players'].sort_by { |_key, value| value }.reverse.to_h
  players.each do |key, value|
    desc += "**#{arr['players2'][key]}:** #{value}\n"
    $players[key]['hr'] += 1 if value > 50 + $players[key]['hr']
  end
  e = embed(arr['name'], desc.chomp("\n"))
  e.author[:icon_url] = 'http://monsterhunteronline.in/monsters/images/' +
                        arr['icon'].to_s + '.png'
  e.color = arr['color']
  e.thumbnail = { url: 'http://i.imgur.com/0MskAc1.png' }
  e
end

def shop(arr)
  desc = ''
  x = 1
  arr.each do |key, _value|
    desc += "**#{x}. #{key['name']}:** #{key['price']}\n"
    x += 1
  end
  embed('Here is the shop listing!', desc.chomp("\n"))
end
