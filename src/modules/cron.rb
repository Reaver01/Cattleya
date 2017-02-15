module Bot
  # Schedules Cron jobs
  module Cron
    # Does something every 10 mins
    SCHEDULER.every '10m' do
      # Spawn monsters in unstable channels
    end

    # Does something every 30 mins
    SCHEDULER.every '30m' do
      BOT.game = 'with ' + MONSTERS.sample['name']
    end

    # Does something every 3 hours
    SCHEDULER.every '3h' do
      $anger = %w(b l v y p w f g).sample
      $hit = %w(c m u d n t e h i o a s r).sample
    end
  end
end
