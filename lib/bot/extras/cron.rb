def cronjobs_start
	s = Rufus::Scheduler.new

	s.every '5m' do
		File.open('botfiles/players.json', 'w') { |f| f.write PLAYERS.to_json }
		File.open('botfiles/CURRENT_UNSTABLE.json', 'w') { |f| f.write CURRENT_UNSTABLE.to_json }
	end

	s.every '10m' do
		UNSTABLE.each do |key, value|
			if value
				a = rand(0..9)
				if a == 0
					unless CURRENT_UNSTABLE.has_key?(key)
						CURRENT_UNSTABLE[key] = MONSTERS[rand(0..(MONSTERS.length - 1))]
						puts CURRENT_UNSTABLE[key]
						begin
							BOT.channel(key.to_s).send_embed 'A Monster has entered the channel!', NewMonster(CURRENT_UNSTABLE[key])
							File.open('botfiles/CURRENT_UNSTABLE.json', 'w') { |f| f.write CURRENT_UNSTABLE.to_json }
						rescue
						end
					end
				end
			end
		end
	end

	s.cron '5 */3 * * *' do
		File.open('botfiles/players.json', 'w') { |f| f.write PLAYERS.to_json }
		File.open('botfiles/CURRENT_UNSTABLE.json', 'w') { |f| f.write CURRENT_UNSTABLE.to_json }
		BOT.stop
	end

	puts 'Cron jobs scheduled!'
end
