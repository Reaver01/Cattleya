require 'rufus-scheduler'
# Schedules all cron jobs
module Cronjobs
  s = Rufus::Scheduler.new

  s.every '5m' do
    File.open('botfiles/current_unstable.json', 'w') do |f|
      f.write $cur_unst.to_json
    end
    File.open('botfiles/logs.json', 'w') { |f| f.write $logs.to_json }
    File.open('botfiles/players.json', 'w') { |f| f.write $players.to_json }
    File.open('botfiles/settings.json', 'w') { |f| f.write $settings.to_json }
  end

  s.every '10m' do
    $unstable.each do |key, value|
      next unless value
      a = rand(0..14)
      next unless a.zero?
      next if $cur_unst.key?(key)
      $cur_unst[key] = MONSTERS.sample
      begin
        BOT.channel(key.to_s).send_embed 'A Monster has entered the channel!',
                                         new_monster($cur_unst[key])
        File.open('botfiles/current_unstable.json', 'w') do |f|
          f.write $cur_unst.to_json
        end
      rescue
        $cur_unst = $cur_unst.without(key)
        mute_log(key.to_s)
      end
    end
  end

  s.every '30m' do
    $settings['game'] = 'with ' +
                        [
                          'Akura Jebia', 'Akura Vashimu', 'Arbiter Estrellian',
                          'Azure Rathalos', 'Baelidae', 'Basarios', 'Berioros',
                          'Blangonga', 'Blue Yian Kut-Ku', 'Bulldrome',
                          'Caeserber', 'Cephadrome', 'Chameleos', 'Chramine',
                          'Conflagration Rathian', 'Congalala',
                          'Crystal Basarios', 'Daimyo Hermitaur', 'Deviljho',
                          'Diablos', 'Doom Estrellian', 'Dread Baelidae',
                          'Elemental Merphistophelin', 'Estrellian',
                          'Flame Blangonga', 'Gendrome', 'Ghost Caeserber',
                          'Gold Congalala', 'Gold Hypnocatrice',
                          'GonnGenn Hermitaur', 'Gravios', 'Gypceros',
                          'Hypnocatrice', 'Ice Chramine', 'Khezu', 'Kirin',
                          'Kushala Daora', 'Lavasioth', 'Lightenna',
                          'Merphistophelin', 'Monoblos',
                          'One-Eared Yian Garuga', 'Onimusha', 'Pink Rathian',
                          'Purple Gypceros', 'Purple Slicemargl', 'Rajang',
                          'Rathalos', 'Rathian', 'Red Khezu',
                          'Rusted Kushala Daora', 'Sandstone Basarios',
                          'Shattered Monoblos', 'Shogun Ceanataur',
                          'Silver Hypnocatrice', 'Slicemargl',
                          'Swordmaster Shogun Ceanataur', 'Tartaronis',
                          'Tigrex', 'Velocidrome', 'White Monoblos',
                          'Yellow Caeserber', 'Yian Garuga', 'Yian Kut-Ku',
                          'Zinogre'
                        ].sample
    BOT.game = $settings['game']
  end

  s.cron '5 */3 * * *' do
    $anger = %w(b l v y p w f g).sample
    $hit = %w(c m u d n t e h i o a s r).sample
  end

  puts '[STARTUP] Cron jobs scheduled!'
end
