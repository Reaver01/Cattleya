module Commands
  # Command Module
  module Notify
    extend Discordrb::Commands::CommandContainer
    command(
      :notify,
      description: 'Toggles pm notifications of level',
      usage: 'notify'
    ) do |event|
      if $players[event.user.id.to_s].key?('messages')
        if $players[event.user.id.to_s]['messages']
          pm_status = false
          begin
            BOT.user(event.user.id.to_s).pm('PM notifications have been toggled off. How sad!')
            event.message.react('💬')
          rescue
            mute_log(event.user.id.to_s)
          end
        else
          pm_status = true
          begin
            BOT.user(event.user.id.to_s).pm('PM notifications have been toggled on! I love sending notifications!')
          rescue
            mute_log(event.user.id.to_s)
          end
        end
      else
        pm_status = true
        begin
          BOT.user(event.user.id.to_s).pm('PM notifications have been toggled on! I love sending notifications!')
          event.message.react('💬')
        rescue
          mute_log(event.user.id.to_s)
        end
      end
      $players[event.user.id.to_s]['messages'] = pm_status
      event.message.delete
      command_log('notify', event.user.name)
      nil
    end
  end
end
