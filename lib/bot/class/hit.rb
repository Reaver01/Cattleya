def hit(event_user, event_channel)
  if $current_unstable.key?(event_channel.id.to_s)
    debug(3, "[HIT] There is a monster in #{event_channel.id}.")
    if $current_unstable[event_channel.id.to_s].key?('intrap')
      debug(5, '[HIT] Monster has intrap key.')
      if $current_unstable[event_channel.id.to_s]['intrap']
        debug(7, '[HIT] Monster is in a trap | Setting modifier.')
        trap_modifier = 1.75
      else
        debug(10, '[HIT] Monster is not in a trap | Setting modifier to 1.')
        trap_modifier = 1
      end
    else
      debug(14, "[HIT] Monster doesn't have intrap key | Setting modifier to 1.")
      trap_modifier = 1
    end
    if $players.key?(event_user.id.to_s)
      debug(18, "[HIT] #{event_user.id} has HR | Setting modifier.")
      hr_modifier = $players[event_user.id.to_s]['hr']
    else
      debug(21, "[HIT] #{event_user.id} doesn't have HR | Setting modifier to 0.")
      hr_modifier = 0
    end
    damage_dealt = 0
    if $current_unstable[event_channel.id.to_s].key?('is_dead')
      debug(26, '[HIT] Monster has is_dead key.')
      if $current_unstable[event_channel.id.to_s]['is_dead'].key?(event_user.id.to_s)
        debug(28, "[HIT] is_dead has key for #{event_user.id}.")
        unless $current_unstable[event_channel.id.to_s]['is_dead'][event_user.id.to_s]
          debug(30, "[HIT] #{event_user.id} is not dead | calculating and dealing damage.")
          damage_dealt = rand(0..(10 + hr_modifier)) * trap_modifier
          damage_dealt = damage_dealt.round
          $current_unstable[event_channel.id.to_s]['hp'] -= damage_dealt
        end
      else
        debug(36, "[HIT] No is_dead key for #{event_user.id} | calculating and dealing damage.")
        damage_dealt = rand(0..(10 + hr_modifier)) * trap_modifier
        damage_dealt = damage_dealt.round
        $current_unstable[event_channel.id.to_s]['hp'] -= damage_dealt
      end
    end
    if $current_unstable[event_channel.id.to_s].key?('players')
      debug(44, '[HIT] Monster has players array.')
      if $current_unstable[event_channel.id.to_s]['players'].key?(event_user.id.to_s)
        debug(46, "[HIT] Key exists for #{event_user.id} | adding damage dealt and name to player arrays.")
        $current_unstable[event_channel.id.to_s]['players'][event_user.id.to_s] += damage_dealt
      else
        debug(50, "[HIT] Key doesn't exist for #{event_user.id} | Creating it and seting damage dealt.")
        $current_unstable[event_channel.id.to_s]['players'][event_user.id.to_s] = damage_dealt
      end
      $current_unstable[event_channel.id.to_s]['players2'][event_user.id.to_s] = event_user.name
    else
      debug(55, '[HIT] Monster does not have players array | Creating it and adding player damage and name.')
      $current_unstable[event_channel.id.to_s]['players'] = { event_user.id.to_s => damage_dealt }
      $current_unstable[event_channel.id.to_s]['players2'] = { event_user.id.to_s => event_user.name }
    end
    if $current_unstable[event_channel.id.to_s]['hp'] < 0
      debug(61, '[HIT] Monster is dead | Generating and displaying results.')
      end_results = $current_unstable[event_channel.id.to_s]
      $current_unstable = $current_unstable.without(event_channel.id.to_s)
      killed_log(event_channel.id.to_s, end_results['name'])
      begin
        event_channel.send_embed 'The monster has been killed! Here are the results:', hunt_end(end_results)
      rescue
        mute_log(event_channel.id.to_s)
      end
    end
  end
end
