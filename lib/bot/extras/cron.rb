def cronjobs_start
	s = Rufus::Scheduler.new

	s.every '5m' do
		File.open('botfiles/players.json', 'w') { |f| f.write $players.to_json }
		File.open('botfiles/curunst.json', 'w') { |f| f.write $curunst.to_json }
	end

	s.every '10m' do
		$unstable.each do |key, value|
			if value
				a = rand(0..9)
				if a == 0
					unless $curunst.has_key?(key)
						$curunst[key] = $monsters[rand(0..($monsters.length - 1))]
						puts $curunst[key]
						begin
							$bot.channel(key.to_s).send_embed 'A Monster has entered the channel!', monster($curunst[key], "no", "no")
							File.open('botfiles/curunst.json', 'w') { |f| f.write $curunst.to_json }
						rescue
						end
					end
				end
			end
		end
	end

	s.cron '5 */3 * * *' do
		File.open('botfiles/players.json', 'w') { |f| f.write $players.to_json }
		File.open('botfiles/curunst.json', 'w') { |f| f.write $curunst.to_json }
		$bot.stop
	end

	puts 'Cron jobs scheduled!'
end
