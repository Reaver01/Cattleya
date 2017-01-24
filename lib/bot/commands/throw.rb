module Commands
  # Command Module
  module Throw
    extend Discordrb::Commands::CommandContainer
    command(
      :throw,
      bucket: :item_throw,
      description: 'Throws something at somebody',
      useage: 'throw <item> <user>'
    ) do |event, *item|
      user_name = item[-1]
      items_indexed = Hash[ITEMS.map.with_index.to_a]
      thrown_item = -1
      if BOT.parse_mention(user_name).nil?
        debug(15, '[THROW] Nobody was mentioned')
        item = item.join(' ').titleize
        threw = false
        thrown_item_index = 0
        (0..ITEMS.length - 1).each do |i|
          if ITEMS[i]['name'] == item
            threw = true
            thrown_item = items_indexed[ITEMS[i]].to_s
            thrown_item_index = i
          end
        end
        if threw
          debug(29, '[THROW] An item was thrown')
          if $players[event.user.id.to_s]['inv'].key?(thrown_item)
            debug(31, '[THROW] user has at least one of the item')
            if ITEMS[thrown_item_index]['throw']
              debug(33, '[THROW] Item can be thrown')
              begin
                event.respond "**#{event.user.name}** threw a **#{item}**!"
                event.message.react('👍')
              rescue
                mute_log(event.channel.id.to_s)
              end
              $players[event.user.id.to_s]['inv'][thrown_item] -= 1
            else
              debug(42, '[THROW] Item cannot be thrown')
              begin
                event.respond "You can't throw **#{item}s**!"
                event.message.react('🚫')
              rescue
                mute_log(event.channel.id.to_s)
              end
            end
            if $players[event.user.id.to_s]['inv'][thrown_item] < 1
              debug(51, '[THROW] Player has no more of that item')
              $players[event.user.id.to_s]['inv'] = $players[event.user.id.to_s]['inv'].without(thrown_item)
            end
            if $current_unstable.key?(event.channel.id.to_s)
              debug(55, '[THROW] There is a monster in the channel')
              damage_dealt = 0
              if item == 'Barrel Bomb S'
                debug(58, '[THROW] Item is a Barrel Bomb S')
                chance_to_hit = if $current_unstable[event.channel.id.to_s].key?('intrap')
                                  if $current_unstable[event.channel.id.to_s]['intrap']
                                    0
                                  else
                                    2
                                  end
                                else
                                  2
                                end
                debug(68, "[THROW] Chance to hit is #{chance_to_hit}")
                if rand(0..chance_to_hit).zero?
                  debug(70, '[THROW] Monster was hit')
                  damage_dealt = 20
                  $current_unstable[event.channel.id.to_s]['hp'] -= damage_dealt
                  begin
                    event.respond "**#{event.user.name}** hit the **#{$current_unstable[event.channel.id.to_s]['name']}** with a **#{item}**!"
                    event.message.react('👍')
                  rescue
                    mute_log(event.channel.id.to_s)
                  end
                else
                  debug(80, '[THROW] Monster was not hit')
                  begin
                    event.respond "**#{event.user.name}** missed!"
                    event.message.react('😆')
                  rescue
                    mute_log(event.channel.id.to_s)
                  end
                end
              elsif item == 'Barrel Bomb L'
                chance_to_hit = if $current_unstable[event.channel.id.to_s].key?('intrap')
                                  if $current_unstable[event.channel.id.to_s]['intrap']
                                    0
                                  else
                                    1
                                  end
                                else
                                  1
                                end
                if rand(0..chance_to_hit).zero?
                  damage_dealt = 40
                  $current_unstable[event.channel.id.to_s]['hp'] -= damage_dealt
                  begin
                    event.respond "**#{event.user.name}** hit the **#{$current_unstable[event.channel.id.to_s]['name']}** with a **#{item}**!"
                    event.message.react('👍')
                  rescue
                    mute_log(event.channel.id.to_s)
                  end
                else
                  begin
                    event.respond "**#{event.user.name}** missed!"
                    event.message.react('😆')
                  rescue
                    mute_log(event.channel.id.to_s)
                  end
                end
              elsif item == 'Dynamite'
                chance_to_hit = if $current_unstable[event.channel.id.to_s].key?('intrap')
                                  if $current_unstable[event.channel.id.to_s]['intrap']
                                    0
                                  else
                                    3
                                  end
                                else
                                  3
                                end
                if rand(0..chance_to_hit).zero?
                  damage_dealt = 15
                  $current_unstable[event.channel.id.to_s]['hp'] -= damage_dealt
                  begin
                    event.respond "**#{event.user.name}** hit the **#{$current_unstable[event.channel.id.to_s]['name']}** with a **#{item}**!"
                    event.message.react('👍')
                  rescue
                    mute_log(event.channel.id.to_s)
                  end
                else
                  begin
                    event.respond "**#{event.user.name}** missed!"
                    event.message.react('😆')
                  rescue
                    mute_log(event.channel.id.to_s)
                  end
                end
              elsif item == 'Pickaxe'
                chance_to_hit = if $current_unstable[event.channel.id.to_s].key?('intrap')
                                  if $current_unstable[event.channel.id.to_s]['intrap']
                                    0
                                  else
                                    1
                                  end
                                else
                                  1
                                end
                if rand(0..chance_to_hit).zero?
                  damage_dealt = 5
                  $current_unstable[event.channel.id.to_s]['hp'] -= damage_dealt
                  begin
                    event.respond "**#{event.user.name}** hit the **#{$current_unstable[event.channel.id.to_s]['name']}** with a **#{item}**!"
                    event.message.react('👍')
                  rescue
                    mute_log(event.channel.id.to_s)
                  end
                else
                  begin
                    event.respond "**#{event.user.name}** missed!"
                    event.message.react('😆')
                  rescue
                    mute_log(event.channel.id.to_s)
                  end
                end
              elsif item == 'Dung Bomb'
                chance_to_hit = if $current_unstable[event.channel.id.to_s].key?('intrap')
                                  if $current_unstable[event.channel.id.to_s]['intrap']
                                    0
                                  else
                                    3
                                  end
                                else
                                  3
                                end
                if rand(0..chance_to_hit).zero?
                  empty_channels = []
                  $unstable.each do |key, value|
                    if value
                      next unless $current_unstable.key?(key)
                      empty_channels.push(key)
                    end
                  end
                  if empty_channels.length.zero?
                    event.respond 'There are no channels for the monster to go!'
                  else
                    new_channel = empty_channels.sample
                    $current_unstable[new_channel] = $current_unstable[event.channel.id.to_s]
                    begin
                      event.respond "**#{event.user.name}** hit the **#{$current_unstable[event.channel.id.to_s]['name']}** with a **#{item}**!"
                      event.message.react('💩')
                    rescue
                      mute_log(event.channel.id.to_s)
                    end
                    $current_unstable = $current_unstable.without(event.channel.id.to_s)
                    begin
                      BOT.channel(new_channel).send_embed "A Monster has entered the channel!\nThis monster came from **#{event.channel.name}** via a Dung Bomb!", new_monster($current_unstable[new_channel])
                      event.respond "The monster has moved to **#{BOT.channel(new_channel).name}**"
                    rescue
                      event.respond "**#{BOT.channel(new_channel).name}** has muted me and isn't allowed to spawn monsters."
                      event.message.react('🚫')
                      $current_unstable[event.channel.id.to_s] = $current_unstable[new_channel]
                      $current_unstable = $current_unstable.without(new_channel)
                      $unstable[new_channel.to_s] = false
                      mute_log(new_channel.to_s)
                    end
                    File.open('botfiles/current_unstable.json', 'w') { |f| f.write $current_unstable.to_json }
                  end
                else
                  begin
                    event.respond "**#{event.user.name}** missed!"
                    event.message.react('😆')
                  rescue
                    mute_log(event.channel.id.to_s)
                  end
                end
              end
              unless damage_dealt.zero?
                debug(222, '[THROW] Damage was dealt to monster')
                if $current_unstable[event.channel.id.to_s].key?('players')
                  if $current_unstable[event.channel.id.to_s]['players'].key?(event.user.id.to_s)
                    $current_unstable[event.channel.id.to_s]['players'][event.user.id.to_s] += damage_dealt
                  else
                    $current_unstable[event.channel.id.to_s]['players'][event.user.id.to_s] = damage_dealt
                  end
                  $current_unstable[event.channel.id.to_s]['players2'][event.user.id.to_s] = event.user.name
                else
                  $current_unstable[event.channel.id.to_s]['players'] = { event.user.id.to_s => damage_dealt }
                  $current_unstable[event.channel.id.to_s]['players2'] = { event.user.id.to_s => event.user.name }
                end
              end
            end
          else
            debug(237, '[THROW] User does not have that item to throw')
            begin
              event.respond "**#{event.user.name}** doesn't have any **#{item}s** to throw!"
              event.message.react('🚫')
            rescue
              mute_log(event.channel.id.to_s)
            end
          end
        end
      else
        debug(247, '[THROW] A user was mentioned')
        item = item.first item.size - 1
        item = item.join(' ').titleize
        threw = false
        thrown_item_index = 0
        (0..ITEMS.length - 1).each do |i|
          if ITEMS[i]['name'] == item
            threw = true
            thrown_item = items_indexed[ITEMS[i]].to_s
            thrown_item_index = i
            puts thrown_item_index
          end
        end
        if threw
          debug(262, '[THROW] An item was thrown')
          if $players[event.user.id.to_s]['inv'].key?(thrown_item)
            debug(264, '[THROW] User has that item in their inventory')
            if ITEMS[thrown_item_index]['throw']
              debug(266, '[THROW] Item can be thrown')
              begin
                event.respond "**#{event.user.name}** threw a **#{item}** at #{user_name}!"
                event.message.react('🤣')
              rescue
                mute_log(event.channel.id.to_s)
              end
              $players[event.user.id.to_s]['inv'][thrown_item] -= 1
            else
              debug(275, '[THROW] Item cannot be thrown')
              begin
                event.respond "You can't throw **#{item}s**!"
                event.message.react('🚫')
              rescue
                mute_log(event.channel.id.to_s)
              end
            end
            if $players[event.user.id.to_s]['inv'][thrown_item] < 1
              debug(284, '[THROW] Player has no more of that item')
              $players[event.user.id.to_s]['inv'] = $players[event.user.id.to_s]['inv'].without(thrown_item)
            end
          else
            debug(288, '[THROW] Player does not have any of that item')
            begin
              event.respond "**#{event.user.name}** doesn't have any **#{item}s** to throw!"
              event.message.react('🚫')
            rescue
              mute_log(event.channel.id.to_s)
            end
          end
        end
      end
      event.message.delete
      command_log('throw', event.user.name)
      nil
    end
  end
end
