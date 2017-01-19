def cronjobs_start
	s = Rufus::Scheduler.new
	#saves the databases every 5 mins
	s.every '5m' do
		File.open('botfiles/current_unstable.json', 'w') { |f| f.write $current_unstable.to_json }
		File.open('botfiles/logs.json', 'w') { |f| f.write $logs.to_json }
		File.open('botfiles/players.json', 'w') { |f| f.write $players.to_json }
	end
	#every 10 mins generates a random number and will put a monster in the channel if it's a 0
	s.every '10m' do
		$unstable.each do |key, value|
			if value
				a = rand(0..9)
				if a == 0
					unless $current_unstable.has_key?(key)
						$current_unstable[key] = $monsters.sample
						puts $current_unstable[key]
						begin
							BOT.channel(key.to_s).send_embed 'A Monster has entered the channel!', new_monster($current_unstable[key])
							File.open('botfiles/current_unstable.json', 'w') { |f| f.write $current_unstable.to_json }
						rescue
						end
					end
				end
			end
		end
	end
	#saves everything and restarts the bot the 5th minute of every 3rd hour for updates
	s.cron '5 */3 * * *' do
		File.open('botfiles/current_unstable.json', 'w') { |f| f.write $current_unstable.to_json }
		File.open('botfiles/logs.json', 'w') { |f| f.write $logs.to_json }
		File.open('botfiles/players.json', 'w') { |f| f.write $players.to_json }
		BOT.stop
	end

	puts 'Cron jobs scheduled!'
end
