def cronjobs_start
	s = Rufus::Scheduler.new

	s.every '5m' do
		File.open('botfiles/players.json', 'w') { |f| f.write $players.to_json }
	end

	s.every '10m' do
		$unstable.each do |key, value|
			if value
				
			end
		end
	end

	s.cron '5 */3 * * *' do
		File.open('botfiles/players.json', 'w') { |f| f.write $players.to_json }
		$bot.stop
	end

	puts 'Cron jobs scheduled!'
end
