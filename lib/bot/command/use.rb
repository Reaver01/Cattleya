module Commands
  # Command Module
  module Use
    extend Discordrb::Commands::CommandContainer
    command(
      :use,
      bucket: :item_use,
      description: 'Use an item',
      usage: 'use <item> <user>'
    ) do |event, *item|
      user_id = event.user.id.to_s
      channel_id = event.channel.id.to_s
      user_name = item[-1]
      items_indexed = Hash[ITEMS.map.with_index.to_a]
      used_item = -1
      if BOT.parse_mention(user_name).nil?
        item = item.join(' ').titleize
        used = false
        used_item_index = 0
        (0..ITEMS.length - 1).each do |i|
          next unless ITEMS[i]['name'] == item
          used = true
          used_item = items_indexed[ITEMS[i]].to_s
          used_item_index = i
        end
        if used
          if $players[user_id]['inv'].key?(used_item)
            if ITEMS[used_item_index]['throw']
              begin
                event.respond "**#{item}s** must be thrown!"
                event.message.react('🚫')
              rescue
                mute_log(channel_id)
              end
            else
              begin
                event.respond "**#{event.user.name}** used a **#{item}**!"
                event.message.react('👍')
              rescue
                mute_log(channel_id)
              end
              $players[user_id]['inv'][used_item] -= 1
            end
            if $players[user_id]['inv'][used_item] < 1
              $players[user_id]['inv'] = $players[user_id]['inv'].without(
                used_item
              )
            end
            if $cur_unst.key?(channel_id)
              if item == 'Shock Trap'
                if %w(shock both).include? $cur_unst[channel_id]['trap']
                  $cur_unst[channel_id]['intrap'] = true
                  $cur_unst[channel_id]['traptime'] = Time.now
                  begin
                    event.respond "The #{$cur_unst[channel_id]['name']} has " \
                                  'been trapped!'
                    event.message.react('👍')
                  rescue
                    mute_log(channel_id)
                  end
                else
                  begin
                    event.respond "The #{$cur_unst[channel_id]['name']} can't" \
                                  ' be trapped by this type of trap!'
                    event.message.react('🚫')
                  rescue
                    mute_log(channel_id)
                  end
                end
              end
              if item == 'Pitfall Trap'
                if %w(pitfall both).include? $cur_unst[channel_id]['trap']
                  $cur_unst[channel_id]['intrap'] = true
                  $cur_unst[channel_id]['traptime'] = Time.now
                  begin
                    event.respond "The #{$cur_unst[channel_id]['name']} has " \
                                  'been trapped!'
                    event.message.react('👍')
                  rescue
                    mute_log(channel_id)
                  end
                else
                  begin
                    event.respond "The #{$cur_unst[channel_id]['name']} can't" \
                                  ' be trapped by this type of trap!'
                    event.message.react('🚫')
                  rescue
                    mute_log(channel_id)
                  end
                end
              end
            end
          else
            begin
              event.respond "**#{event.user.name}** doesn't have any " \
                            "**#{item}s** to use!"
              event.message.react('🚫')
            rescue
              mute_log(channel_id)
            end
          end
        end
      else
        item = item.first item.size - 1
        item = item.join(' ').titleize
        used = false
        used_item_index = 0
        (0..ITEMS.length - 1).each do |i|
          next unless ITEMS[i]['name'] == item
          used = true
          used_item = items_indexed[ITEMS[i]].to_s
          used_item_index = i
        end
        if used
          if $players[user_id]['inv'].key?(used_item)
            if ITEMS[used_item_index]['throw']
              begin
                event.respond "**#{item}s** must be thrown!"
                event.message.react('🚫')
              rescue
                mute_log(channel_id)
              end
            else
              begin
                event.respond "**#{event.user.name}** used a **#{item}** on " \
                              "#{user_name}!"
                event.message.react('👍')
              rescue
                mute_log(channel_id)
              end
              $players[user_id]['inv'][used_item] -= 1
            end
            if $players[user_id]['inv'][used_item] < 1
              $players[user_id]['inv'] = $players[user_id]['inv'].without(
                used_item
              )
            end
          else
            begin
              event.respond "**#{event.user.name}** doesn't have any " \
                            "**#{item}s** to use!"
              event.message.react('🚫')
            rescue
              mute_log(channel_id)
            end
          end
        end
      end
      event.message.delete
      command_log('use', event.user.name)
      nil
    end
  end
end
