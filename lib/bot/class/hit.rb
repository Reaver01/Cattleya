def hit(user, channel)
  if $cur_unst.key?(channel.id.to_s)
    if $cur_unst[channel.id.to_s].key?('intrap')
      trap_modifier = if $cur_unst[channel.id.to_s]['intrap']
                        1.75
                      else
                        1
                      end
    else
      trap_modifier = 1
    end
    hr_modifier = if $players.key?(user.id.to_s)
                    $players[user.id.to_s]['hr']
                  else
                    0
                  end
    damage = 0
    if $cur_unst[channel.id.to_s].key?('is_dead')
      if $cur_unst[channel.id.to_s]['is_dead'].key?(
        user.id.to_s
      )
        unless $cur_unst[channel.id.to_s]['is_dead'][user.id.to_s]
          damage = rand(0..(10 + hr_modifier)) * trap_modifier
          damage = damage.round
          $cur_unst[channel.id.to_s]['hp'] -= damage
        end
      else
        damage = rand(0..(10 + hr_modifier)) * trap_modifier
        damage = damage.round
        $cur_unst[channel.id.to_s]['hp'] -= damage
      end
    end
    if $cur_unst[channel.id.to_s].key?('players')
      if $cur_unst[channel.id.to_s]['players'].key?(user.id.to_s)
        $cur_unst[channel.id.to_s]['players'][user.id.to_s] += damage
      else
        $cur_unst[channel.id.to_s]['players'][user.id.to_s] = damage
      end
      $cur_unst[channel.id.to_s]['players2'][user.id.to_s] = user.name
    else
      $cur_unst[channel.id.to_s]['players'] = { user.id.to_s => damage }
      $cur_unst[channel.id.to_s]['players2'] = {
        user.id.to_s => user.name
      }
    end
    if $cur_unst[channel.id.to_s]['hp'] < 0
      end_results = $cur_unst[channel.id.to_s]
      $cur_unst = $cur_unst.without(channel.id.to_s)
      killed_log(channel.id.to_s, end_results['name'])
      begin
        channel.send_embed 'The monster has been killed! Here are the results:',
                           hunt_end(end_results)
      rescue
        mute_log(channel.id.to_s)
      end
    end
  end
end
