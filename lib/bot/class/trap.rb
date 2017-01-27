def trap(channel, event_timestamp)
  channel_id = channel.id.to_s
  if $cur_unst.key?(channel_id)
    if $cur_unst[channel_id].key?('traptime')
      debug(4, '[TRAP] Monster has a traptime value.')
      if TimeDifference.between(
        $cur_unst[channel_id]['traptime'],
        event_timestamp
      ).in_minutes > 2
        $cur_unst[channel_id]['intrap'] = false
        $cur_unst[channel_id] = $cur_unst[channel_id].without(
          'traptime'
        )
        begin
          BOT.channel(channel_id).send_message(
            "The #{$cur_unst[channel_id]['name']} has escaped the trap!"
          )
        rescue
          mute_log(channel_id)
        end
      end
    end
  end
end
