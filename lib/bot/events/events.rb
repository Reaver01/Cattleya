module Events
  extend Discordrb::EventContainer
  message do |event|
  	puts event.user.id
  	if $players.key?(event.user.id.to_s)
  		$players[event.user.id.to_s]['mcount'] += 1
  	else
  		$players[event.user.id.to_s] = {'mcount'=>1, 'zenny'=>100, 'inv'=>[{'name'=>'Para Trap', 'num'=>1}]}
  	end
  end
end