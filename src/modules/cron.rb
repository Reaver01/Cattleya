module Bot
  # Schedules Cron jobs
  module Cron
    # Does something every 10 mins
    SCHEDULER.every '10m' do
      begin
        # Spawn monsters in unstable channels
        Database::UnstableChannel.each do |channel|
          next unless channel.unstable && rand(0..14).zero?
          current_monster = Database::ActiveMonster.current(channel.channel_id)
          spawned_monster = Database::ActiveMonster.spawn(channel.channel_id)
          next if current_monster
          BOT.channel(channel.channel_id).send_embed(
            'A Monster has entered the channel!',
            spawned_monster.initial_embed
          )
        end
      rescue
        puts 'Spawning monster failed'
      end
    end

    # Does something every 30 mins
    SCHEDULER.every '30m' do
      begin
        BOT.game = 'with ' + Database::Monster[rand(1..Database::Monster.count)].name
      rescue
        puts 'Setting game failed'
      end
    end

    # Does something every 3 hours
    SCHEDULER.every '3h' do
      begin
        $anger = %w(b l v y p w f g).sample
        $hit = %w(c m u d n t e h i o a s r).sample
      rescue
        puts 'Changing variables failed'
      end
    end

    # Does something every 24 hours
    SCHEDULER.every '24h' do
      BOT.stop
      exit
    end
  end
end
