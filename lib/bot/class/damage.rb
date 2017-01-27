def damage(user, channel, message, timestamp)
  if $current_unstable.key?(channel.id.to_s)
    if rand(0..9).zero?
      if $current_unstable[channel.id.to_s].key?('players')
        if $players.key?(user.id.to_s)
          message.react('💥')
          damage_done = 0
          if $current_unstable[channel.id.to_s].key?('is_dead')
            if $current_unstable[channel.id.to_s]['is_dead'].key?(user.id.to_s)
              unless $current_unstable[channel.id.to_s]['is_dead'][user.id.to_s]
                damage_done = rand(0..value)
              end
            else
              damage_done = rand(0..value)
            end
          else
            damage_done = rand(0..value)
          end
          damage_done = damage_done.round
          unless damage_done.zero?
            if $players[user.id.to_s]['messages']
              begin
                BOT.user(user.id.to_s).pm(
                  "You have taken **#{damage_done} damage** from the " \
                  "**#{$current_unstable[channel.id.to_s]['name']}**"
                )
              rescue
                mute_log(user.id.to_s)
              end
            end
            unless $players[user.id.to_s].key?('max_hp')
              new_hp = 500 + ($players[user.id.to_s]['level'] * 10)
              $players[user.id.to_s]['max_hp'] = new_hp
              $players[user.id.to_s]['current_hp'] = new_hp
            end
            $players[user.id.to_s]['current_hp'] -= damage_done
            if $players[user.id.to_s]['current_hp'] < 0
              if $players[user.id.to_s]['messages']
                begin
                  BOT.user(user.id.to_s).pm('You have taken too much damage! The felynes will take approximately 5 minutes to restore you to full power.')
                rescue
                  mute_log(user.id.to_s)
                end
              end
              if $current_unstable[event_channel.id.to_s].key?('is_dead')
                $current_unstable[event_channel.id.to_s]['is_dead'][user.id.to_s] = true
              else
                $current_unstable[event_channel.id.to_s]['is_dead'] = { user.id.to_s => true }
              end
              $players[user.id.to_s]['death_time'] = event_timestamp
            end
          end
        end
      end
    end
  end
  if $players.key?(user.id.to_s)
    if $players[user.id.to_s].key?('death_time')
      if TimeDifference.between(
        $players[user.id.to_s]['death_time'], timestamp
      ).in_minutes > 5
        $players[user.id.to_s] = $players[user.id.to_s].without(
          'death_time'
        )
        if $current_unstable.key?(channel.id.to_s)
          if $current_unstable[channel.id.to_s].key?('is_dead')
            $current_unstable[channel.id.to_s]['is_dead'][user.id.to_s] = false
          else
            $current_unstable[channel.id.to_s]['is_dead'] = {
              user.id.to_s => false
            }
          end
        end
        $players[user.id.to_s]['current_hp'] = $players[user.id.to_s]['max_hp']
      end
    end
  end
end
