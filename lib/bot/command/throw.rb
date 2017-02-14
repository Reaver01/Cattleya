module Commands
  # Command Module
  module Throw
    extend Discordrb::Commands::CommandContainer
    command(
      :throw,
      bucket: :item_throw,
      description: 'Throws something at somebody',
      usage: 'throw <item> <user>'
    ) do |event, *item|
      user_id = event.user.id.to_s
      channel_id = event.channel.id.to_s
      user_name = item[-1]
      items_indexed = Hash[ITEMS.map.with_index.to_a]
      thrown_item = -1
      if BOT.parse_mention(user_name).nil?
        item = item.join(' ').titleize
        threw = false
        thrown_item_index = 0
        (0..ITEMS.length - 1).each do |i|
          next unless ITEMS[i]['name'] == item
          threw = true
          thrown_item = items_indexed[ITEMS[i]].to_s
          thrown_item_index = i
        end
        if threw
          if $players[user_id]['inventory'].key?(thrown_item)
            if ITEMS[thrown_item_index]['throw']
              begin
                event.respond "**#{event.user.name}** threw a **#{item}**!"
                event.message.react('👍')
              rescue
                mute_log(channel_id)
              end
              $players[user_id]['inventory'][thrown_item] -= 1
            else
              begin
                event.respond "You can't throw **#{item}s**!"
                event.message.react('🚫')
              rescue
                mute_log(channel_id)
              end
            end
            if $players[user_id]['inventory'][thrown_item] < 1
              $players[user_id]['inventory'] = $players[user_id]['inventory'].without(
                thrown_item
              )
            end
            if $cur_unst.key?(channel_id)
              damage = 0
              if item == 'Barrel Bomb S'
                chance_to_hit = if $cur_unst[channel_id].key?('intrap')
                                  if $cur_unst[channel_id]['intrap']
                                    0
                                  else
                                    2
                                  end
                                else
                                  2
                                end
                if rand(0..chance_to_hit).zero?
                  damage = 20
                  $cur_unst[channel_id]['hp'] -= damage
                  begin
                    event.respond "**#{event.user.name}** hit the **" +
                                  $cur_unst[channel_id]['name'].to_s +
                                  "** with a **#{item}**!"
                    event.message.react('👍')
                  rescue
                    mute_log(channel_id)
                  end
                else
                  begin
                    event.respond "**#{event.user.name}** missed!"
                    event.message.react('😆')
                  rescue
                    mute_log(channel_id)
                  end
                end
              elsif item == 'Barrel Bomb L'
                chance_to_hit = if $cur_unst[channel_id].key?('intrap')
                                  if $cur_unst[channel_id]['intrap']
                                    0
                                  else
                                    1
                                  end
                                else
                                  1
                                end
                if rand(0..chance_to_hit).zero?
                  damage = 40
                  $cur_unst[channel_id]['hp'] -= damage
                  begin
                    event.respond "**#{event.user.name}** hit the **" +
                                  $cur_unst[channel_id]['name'].to_s +
                                  "** with a **#{item}**!"
                    event.message.react('👍')
                  rescue
                    mute_log(channel_id)
                  end
                else
                  begin
                    event.respond "**#{event.user.name}** missed!"
                    event.message.react('😆')
                  rescue
                    mute_log(channel_id)
                  end
                end
              elsif item == 'Dynamite'
                chance_to_hit = if $cur_unst[channel_id].key?('intrap')
                                  if $cur_unst[channel_id]['intrap']
                                    0
                                  else
                                    3
                                  end
                                else
                                  3
                                end
                if rand(0..chance_to_hit).zero?
                  damage = 15
                  $cur_unst[channel_id]['hp'] -= damage
                  begin
                    event.respond "**#{event.user.name}** hit the **" +
                                  $cur_unst[channel_id]['name'].to_s +
                                  "** with a **#{item}**!"
                    event.message.react('👍')
                  rescue
                    mute_log(channel_id)
                  end
                else
                  begin
                    event.respond "**#{event.user.name}** missed!"
                    event.message.react('😆')
                  rescue
                    mute_log(channel_id)
                  end
                end
              elsif item == 'Pickaxe'
                chance_to_hit = if $cur_unst[channel_id].key?('intrap')
                                  if $cur_unst[channel_id]['intrap']
                                    0
                                  else
                                    1
                                  end
                                else
                                  1
                                end
                if rand(0..chance_to_hit).zero?
                  damage = 5
                  $cur_unst[channel_id]['hp'] -= damage
                  begin
                    event.respond "**#{event.user.name}** hit the **" +
                                  $cur_unst[channel_id]['name'].to_s +
                                  "** with a **#{item}**!"
                    event.message.react('👍')
                  rescue
                    mute_log(channel_id)
                  end
                else
                  begin
                    event.respond "**#{event.user.name}** missed!"
                    event.message.react('😆')
                  rescue
                    mute_log(channel_id)
                  end
                end
              elsif item == 'Dung Bomb'
                chance_to_hit = if $cur_unst[channel_id].key?('intrap')
                                  if $cur_unst[channel_id]['intrap']
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
                      next if $cur_unst.key?(key)
                      empty_channels.push(key)
                    end
                  end
                  if empty_channels.length.zero?
                    event.respond 'There are no channels for the monster to go!'
                  else
                    channel = empty_channels.sample
                    $cur_unst[channel] = $cur_unst[channel_id]
                    begin
                      event.respond "**#{event.user.name}** hit the **" +
                                    $cur_unst[channel_id]['name'].to_s +
                                    "** with a **#{item}**!"
                      event.message.react('💩')
                    rescue
                      mute_log(channel_id)
                    end
                    $cur_unst = $cur_unst.without(channel_id)
                    begin
                      BOT.channel(
                        channel
                      ).send_embed "A Monster has entered the channel!\n" \
                                   'This monster came from **' +
                                   event.channel.name.to_s +
                                   '** via a Dung Bomb!',
                                   new_monster($cur_unst[channel])
                      event.respond 'The monster has moved to ' \
                                    "**#{BOT.channel(channel).name}**"
                    rescue
                      event.respond "**#{BOT.channel(channel).name}** has " \
                                    "muted me and isn't allowed to spawn " \
                                    'monsters.'
                      event.message.react('🚫')
                      $cur_unst[channel_id] = $cur_unst[channel]
                      $cur_unst = $cur_unst.without(channel)
                      $unstable[channel.to_s] = false
                      mute_log(channel.to_s)
                    end
                    File.open('botfiles/current_unstable.json', 'w') do |f|
                      f.write $cur_unst.to_json
                    end
                  end
                else
                  begin
                    event.respond "**#{event.user.name}** missed!"
                    event.message.react('😆')
                  rescue
                    mute_log(channel_id)
                  end
                end
              end
              unless damage.zero?
                if $cur_unst[channel_id].key?('players')
                  if $cur_unst[channel_id]['players'].key?(user_id)
                    $cur_unst[channel_id]['players'][user_id] += damage
                  else
                    $cur_unst[channel_id]['players'][user_id] = damage
                  end
                  $cur_unst[channel_id]['players2'][user_id] = event.user.name
                else
                  $cur_unst[channel_id]['players'] = {
                    user_id => damage
                  }
                  $cur_unst[channel_id]['players2'] = {
                    user_id => event.user.name
                  }
                end
              end
            end
          else
            begin
              event.respond "**#{event.user.name}** doesn't have any " \
                            "**#{item}s** to throw!"
              event.message.react('🚫')
            rescue
              mute_log(channel_id)
            end
          end
        end
      else
        item = item.first item.size - 1
        item = item.join(' ').titleize
        threw = false
        thrown_item_index = 0
        (0..ITEMS.length - 1).each do |i|
          next unless ITEMS[i]['name'] == item
          threw = true
          thrown_item = items_indexed[ITEMS[i]].to_s
          thrown_item_index = i
        end
        if threw
          if $players[user_id]['inventory'].key?(thrown_item)
            if ITEMS[thrown_item_index]['throw']
              begin
                event.respond "**#{event.user.name}** threw a **#{item}** at " \
                              "#{user_name}!"
                event.message.react('🤣')
              rescue
                mute_log(channel_id)
              end
              $players[user_id]['inventory'][thrown_item] -= 1
            else
              begin
                event.respond "You can't throw **#{item}s**!"
                event.message.react('🚫')
              rescue
                mute_log(channel_id)
              end
            end
            if $players[user_id]['inventory'][thrown_item] < 1
              $players[user_id]['inventory'] = $players[user_id]['inventory'].without(
                thrown_item
              )
            end
          else
            begin
              event.respond "**#{event.user.name}** doesn't have any " \
                            "**#{item}s** to throw!"
              event.message.react('🚫')
            rescue
              mute_log(channel_id)
            end
          end
        end
      end
      event.message.delete unless event.message.channel.pm?
      command_log('throw', event.user.name)
      nil
    end
  end
end
