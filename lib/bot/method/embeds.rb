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

def armor_piece(arr)
  desc = "Monster: #{arr[2]}\n" \
         "Defense: #{arr[6]}\n" \
         "[Attributes]\n"
  desc += "   Water Res: #{arr[7]}\n" unless arr[7].to_i.zero?
  desc += "   Fire Res: #{arr[8]}\n" unless arr[8].to_i.zero?
  desc += "   Thunder Res: #{arr[9]}\n" unless arr[9].to_i.zero?
  desc += "   Dragon Res: #{arr[10]}\n" unless arr[10].to_i.zero?
  desc += "   Ice Res: #{arr[11]}\n" unless arr[11].to_i.zero?
  desc += "   Mosaic Slots: #{arr[5]}\n" \
          "[Passive Skills]\n"
  desc += "   #{arr[38]}: #{arr[39]}\n" unless arr[39].to_i.zero?
  desc += "   #{arr[40]}: #{arr[41]}\n" unless arr[41].to_i.zero?
  desc += "   #{arr[42]}: #{arr[43]}\n" unless arr[43].to_i.zero?
  desc += "   #{arr[44]}: #{arr[45]}\n" unless arr[45].to_i.zero?
  desc += "   #{arr[46]}: #{arr[47]}\n" unless arr[47].to_i.zero?
  thumbnail_color = Miro::DominantColors.new(
    "http://monsterhunteronline.in/images/item/#{arr[13]}.png"
  )
  thumbnail_color = thumbnail_color.to_hex[0]
  thumbnail_color = thumbnail_color.slice! '#'
  e = embed(arr[1], desc)
  e.thumbnail = {
    url: "http://monsterhunteronline.in/images/item/#{arr[13]}.png"
  }
  e.footer = { text: arr[0] }
  e.color = thumbnail_color
  e
end
