module Commands
  # Command Module
  module Notify
    extend Discordrb::Commands::CommandContainer
    command(
      :debug,
      description: 'Toggles debugging',
      usage: 'debug',
      help_available: false,
      permission_level: 999
    ) do |event|
      if $settings.key?('debug')
        if $settings['debug']
          debug = false
          begin
            m = 'DEBUG state has been toggled off.'
          rescue
            mute_log(event.channel.id.to_s)
          end
        else
          debug = true
          begin
            m = 'DEBUG state has been toggled on.'
          rescue
            mute_log(event.channel.id.to_s)
          end
        end
      else
        debug = true
        begin
          m = 'DEBUG state has been toggled on.'
        rescue
          mute_log(event.channel.id.to_s)
        end
      end
      $settings['debug'] = debug
      File.open('botfiles/settings.json', 'w') { |f| f.write $settings.to_json }
      event.message.delete unless event.message.channel.pm?
      command_log('debug', event.user.name)
      m
    end
  end
end
