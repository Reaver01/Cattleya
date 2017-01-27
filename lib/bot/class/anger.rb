def anger(event_channel)
  if $current_unstable.key?(event_channel.id.to_s)
    unless $current_unstable[event_channel.id.to_s].key?('angry')
      $current_unstable[event_channel.id.to_s]['angry'] = false
    end
    unless $current_unstable[event_channel.id.to_s]['angry']
      if $current_unstable[event_channel.id.to_s].key?('anger')
        $current_unstable[event_channel.id.to_s]['anger'] += 1
      else
        $current_unstable[event_channel.id.to_s]['anger'] = 1
      end
      if $current_unstable[event_channel.id.to_s]['anger'] > 50
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
