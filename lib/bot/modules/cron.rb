require 'rufus-scheduler'

module Cronjobs
	s = Rufus::Scheduler.new

	s.every '5m' do
		File.open('botfiles/current_unstable.json', 'w') { |f| f.write $current_unstable.to_json }
		File.open('botfiles/logs.json', 'w') { |f| f.write $logs.to_json }
		File.open('botfiles/players.json', 'w') { |f| f.write $players.to_json }
	end

	s.every '10m' do
		$unstable.each do |key, value|
			if value
				a = rand(0..9)
				if a == 0
					unless $current_unstable.has_key?(key)
						$current_unstable[key] = $monsters.sample
						begin
							BOT.channel(key.to_s).send_embed 'A Monster has entered the channel!', new_monster($current_unstable[key])
							File.open('botfiles/current_unstable.json', 'w') { |f| f.write $current_unstable.to_json }
						rescue
							$current_unstable = $current_unstable.without(key)
							mute_log(key.to_s)
						end
					end
				end
			end
		end
	end

	s.cron '5 */3 * * *' do
		File.open('botfiles/current_unstable.json', 'w') { |f| f.write $current_unstable.to_json }
		File.open('botfiles/logs.json', 'w') { |f| f.write $logs.to_json }
		File.open('botfiles/players.json', 'w') { |f| f.write $players.to_json }
		BOT.stop
	end

	puts 'Cron jobs scheduled!'
end
