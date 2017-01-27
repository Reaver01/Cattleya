def anger_check(channel, event_timestamp)
  channel_id = channel.id.to_s
  if $cur_unst.key?(channel_id)
    if $cur_unst[channel_id].key?('angertime')
      debug(5, '[ANGERCHECK] Monster has angertime key.')
      if TimeDifference.between(
        $cur_unst[channel_id]['angertime'], event_timestamp
      ).in_minutes > 3
        $cur_unst[channel_id]['angry'] = false
        $cur_unst[channel_id] = $cur_unst[channel_id].without(
          'angertime'
        )
        begin
          event.respond "The #{$cur_unst[channel_id]['name']} is no " \
                        'longer angry!'
        rescue
          mute_log(channel_id)
        end
      end
    end
  end
end
