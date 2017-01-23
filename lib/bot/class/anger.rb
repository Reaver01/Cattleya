def anger(event_channel)
  if $current_unstable.key?(event_channel.id.to_s)
    debug(3, "[ANGER] #{event_channel.id} has a monster in it.")
    unless $current_unstable[event_channel.id.to_s].key?('angry')
      debug(5, '[ANGER] Key for anger doesn\'t exist | Creating and setting false.')
      $current_unstable[event_channel.id.to_s]['angry'] = false
    end
    unless $current_unstable[event_channel.id.to_s]['angry']
      debug(9, '[ANGER] Monster is not angry')
      if $current_unstable[event_channel.id.to_s].key?('anger')
        debug(11, '[ANGER] Monster has anger key | Adding 1 to monster\'s anger level.')
        $current_unstable[event_channel.id.to_s]['anger'] += 1
      else
        debug(14, '[ANGER] Monster doesn\'t have anger key | Creating it and setting to 1.')
        $current_unstable[event_channel.id.to_s]['anger'] = 1
      end
      if $current_unstable[event_channel.id.to_s]['anger'] > 50
        debug(18, '[ANGER] Anger level has reached 50.')
        $current_unstable[event_channel.id.to_s]['angry'] = true
        $current_unstable[event_channel.id.to_s]['angertime'] = Time.now
        $current_unstable[event_channel.id.to_s]['anger'] = 0
        begin
          BOT.channel(event_channel.id.to_s).send_message("The #{$current_unstable[event_channel.id.to_s]['name']} has become angry!")
        rescue
          mute_log(event_channel.id.to_s)
        end
      end
    end
  end
end
