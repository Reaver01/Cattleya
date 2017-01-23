module Commands
  # Command Module
  module Stats
    extend Discordrb::Commands::CommandContainer
    command(
      :stats,
      bucket: :info,
      description: 'Responds with bot stats',
      useage: 'stats'
    ) do |event|
      desc = "Commands used:\n"
      if $logs.key?('commands')
        $logs['commands'].each do |key, value|
          desc += "**#{key}:** #{value}\n"
        end
      end
      if $logs.key?('monsters_killed')
        desc += "\nMonsters killed:\n"
        $logs['monsters_killed'].each do |key, value|
          desc += "**#{key}:** #{value}\n"
        end
      end
      e = embed('Bot statistics:', desc.chomp("\n"))
      begin
        event.channel.send_embed '', e
      rescue
        mute_log(event.channel.id.to_s)
      end
      command_log('stats', event.user.name)
      nil
    end
  end
end
