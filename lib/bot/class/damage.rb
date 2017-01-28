def damage(user, channel, message, timestamp)
  channel_id = channel.id.to_s
  user_id = user.id.to_s
  if $cur_unst.key?(channel_id)
    if rand(0..9).zero?
      if $cur_unst[channel_id].key?('players')
        value = if $cur_unst[channel_id]['players'].key?(user_id)
                  $cur_unst[channel_id]['players'][user_id]
                else
                  0
                end
        if $players.key?(user_id)
          message.react('💥')
          damage_done = 0
          if $cur_unst[channel_id].key?('is_dead')
            if $cur_unst[channel_id]['is_dead'].key?(user_id)
              unless $cur_unst[channel_id]['is_dead'][user_id]
                damage_done = rand(0..value)
              end
            else
              damage_done = rand(0..value)
            end
          else
            damage_done = rand(0..value)
          end
          damage_done = damage_done.round
          puts damage_done
          unless damage_done.zero?
            if $players[user_id]['messages']
              begin
                BOT.user(user_id).pm(
                  "You have taken **#{damage_done} damage** from the " \
                  "**#{$cur_unst[channel_id]['name']}**"
                )
              rescue
                mute_log(user_id)
              end
            end
            unless $players[user_id].key?('max_hp')
              new_hp = 500 + ($players[user_id]['level'] * 10)
              $players[user_id]['max_hp'] = new_hp
              $players[user_id]['current_hp'] = new_hp
            end
            $players[user_id]['current_hp'] -= damage_done
            if $players[user_id]['current_hp'] < 0
              if $players[user_id]['messages']
                begin
                  BOT.user(user_id).pm('You have taken too much damage! ' \
                                       'The felynes will take approximately ' \
                                       '5 minutes to restore you to full power')
                rescue
                  mute_log(user_id)
                end
              end
              if $cur_unst[event_channel_id].key?('is_dead')
                $cur_unst[event_channel_id]['is_dead'][user_id] = true
              else
                $cur_unst[event_channel_id]['is_dead'] = {
                  user_id => true
                }
              end
              $players[user_id]['death_time'] = event_timestamp
            end
          end
        end
      end
    end
  end
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
    end
  end
end
