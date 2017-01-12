def cronjobs_start
	scheduler = Rufus::Scheduler.new

	scheduler.every '5m' do
		File.open('botfiles/players.json', 'w') { |f| f.write $players.to_json }
	end

	scheduler.cron '5 */3 * * *' do
		File.open('botfiles/players.json', 'w') { |f| f.write $players.to_json }
		$bot.stop
	end
	puts 'Cron jobs scheduled!'
end
