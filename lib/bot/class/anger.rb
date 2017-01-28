def anger(event_channel)
  if $cur_unst.key?(event_channel.id.to_s)
    monster_name = $cur_unst[event_channel.id.to_s]['name']
    unless $cur_unst[event_channel.id.to_s].key?('angry')
      $cur_unst[event_channel.id.to_s]['angry'] = false
    end
    unless $cur_unst[event_channel.id.to_s]['angry']
      if $cur_unst[event_channel.id.to_s].key?('anger')
        $cur_unst[event_channel.id.to_s]['anger'] += 1
      else
        $cur_unst[event_channel.id.to_s]['anger'] = 1
      end
      if $cur_unst[event_channel.id.to_s]['anger'] > 100
        $cur_unst[event_channel.id.to_s]['angry'] = true
        $cur_unst[event_channel.id.to_s]['angertime'] = Time.now
        $cur_unst[event_channel.id.to_s]['anger'] = 0
        begin
          BOT.channel(event_channel.id.to_s).send_message(
            "The #{monster_name} has become angry!"
          )
        rescue
          mute_log(event_channel.id.to_s)
        end
      end
    end
  end
end
