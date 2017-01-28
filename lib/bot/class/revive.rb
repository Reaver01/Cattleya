def revive(user, channel, timestamp)
  channel_id = channel.id.to_s
  user_id = user.id.to_s
  if $players.key?(user_id)
    if $players[user_id].key?('death_time')
      if TimeDifference.between(
        $players[user_id]['death_time'], timestamp
      ).in_minutes > 5
        $players[user_id] = $players[user_id].without(
          'death_time'
        )
        if $cur_unst.key?(channel_id)
          if $cur_unst[channel_id].key?('is_dead')
            $cur_unst[channel_id]['is_dead'][user_id] = false
          else
            $cur_unst[channel_id]['is_dead'] = {
              user_id => false
            }
          end
        end
        $players[user_id]['current_hp'] = $players[user_id]['max_hp']
      end
    elsif $players[user_id].key?('current_hp')
      $players[user_id]['current_hp'] = $players[user_id]['max_hp'] if $players[user_id]['current_hp'] < 0
    end
  end
end
