module Commands
  # Command Module
  module Use
    extend Discordrb::Commands::CommandContainer
    command(
      :use,
      bucket: :item_use,
      description: 'Use an item',
      useage: 'use <item> <user>'
    ) do |event, *item|
      user_name = item[-1]
      items_indexed = Hash[ITEMS.map.with_index.to_a]
      used_item = -1
      if BOT.parse_mention(user_name).nil?
        item = item.join(' ').titleize
        used = false
        x = 0
        begin
          if ITEMS[x]['name'] == item
            used = true
            used_item = items_indexed[ITEMS[x]].to_s
            used_index = x
          end
          x += 1
        end while x < ITEMS.length
        if used
          if $players[event.user.id.to_s]['inv'].key?(used_item)
            if ITEMS[used_index]['throw']
              begin
                event.respond "**#{item}s** must be thrown!"
                event.message.react('🚫')
              rescue
                mute_log(event.channel.id.to_s)
              end
            else
              begin
                event.respond "**#{event.user.name}** used a **#{item}**!"
                event.message.react('👍')
              rescue
                mute_log(event.channel.id.to_s)
              end
              $players[event.user.id.to_s]['inv'][used_item] -= 1
            end
            if $players[event.user.id.to_s]['inv'][used_item] < 1
              $players[event.user.id.to_s]['inv'] = $players[event.user.id.to_s]['inv'].without(used_item)
            end
            if $current_unstable.key?(event.channel.id.to_s)
              if item == 'Shock Trap'
                if %w(shock both).include? $current_unstable[event.channel.id.to_s]['trap']
                  $current_unstable[event.channel.id.to_s]['intrap'] = true
                  $current_unstable[event.channel.id.to_s]['traptime'] = Time.now
                  begin
                    event.respond "The #{$current_unstable[event.channel.id.to_s]['name']} has been trapped!"
                    event.message.react('👍')
                  rescue
                    mute_log(event.channel.id.to_s)
                  end
                else
                  begin
                    event.respond "The #{$current_unstable[event.channel.id.to_s]['name']} can't be trapped by this type of trap!"
                    event.message.react('🚫')
                  rescue
                    mute_log(event.channel.id.to_s)
                  end
                end
              end
              if item == 'Pitfall Trap'
                if %w(pitfall both).include? $current_unstable[event.channel.id.to_s]['trap']
                  $current_unstable[event.channel.id.to_s]['intrap'] = true
                  $current_unstable[event.channel.id.to_s]['traptime'] = Time.now
                  begin
                    event.respond "The #{$current_unstable[event.channel.id.to_s]['name']} has been trapped!"
                    event.message.react('👍')
                  rescue
                    mute_log(event.channel.id.to_s)
                  end
                else
                  begin
                    event.respond "The #{$current_unstable[event.channel.id.to_s]['name']} can't be trapped by this type of trap!"
                    event.message.react('🚫')
                  rescue
                    mute_log(event.channel.id.to_s)
                  end
                end
              end
            end
          else
            begin
              event.respond "**#{event.user.name}** doesn't have any **#{item}s** to use!"
              event.message.react('🚫')
            rescue
              mute_log(event.channel.id.to_s)
            end
          end
        end
      else
        item = item.first item.size - 1
        item = item.join(' ').titleize
        used = false
        x = 0
        begin
          if ITEMS[x]['name'] == item
            used = true
            used_item = items_indexed[ITEMS[x]].to_s
            used_index = x
          end
          x += 1
        end while x < ITEMS.length
        if used
          if $players[event.user.id.to_s]['inv'].key?(used_item)
            if ITEMS[used_index]['throw']
              begin
                event.respond "**#{item}s** must be thrown!"
                event.message.react('🚫')
              rescue
                mute_log(event.channel.id.to_s)
              end
            else
              begin
                event.respond "**#{event.user.name}** used a **#{item}** on #{user_name}!"
                event.message.react('👍')
              rescue
                mute_log(event.channel.id.to_s)
              end
              $players[event.user.id.to_s]['inv'][used_item] -= 1
            end
            if $players[event.user.id.to_s]['inv'][used_item] < 1
              $players[event.user.id.to_s]['inv'] = $players[event.user.id.to_s]['inv'].without(used_item)
            end
          else
            begin
              event.respond "**#{event.user.name}** doesn't have any **#{item}s** to use!"
              event.message.react('🚫')
            rescue
              mute_log(event.channel.id.to_s)
            end
          end
        end
      end
      begin
        event.message.delete
      rescue
      end
      command_log('use', event.user.name)
      nil
    end
  end
end
