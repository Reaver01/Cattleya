module Commands
  # Command Module
  module Eval
    extend Discordrb::Commands::CommandContainer
    command(
      [:eval, :e],
      description: 'Evaluates code',
      usage: 'eval <code>',
      help_available: false,
      permission_level: 999
    ) do |event, *code|
      begin
        result = eval code.join(' ')
        event.channel.send_embed do |e|
          e.description = result.to_s
          e.color = 0x00ff00
        end
      rescue => error
        event.channel.send_embed do |e|
          e.color = 0xff0000
          e.description = "```#{error}```"
          e.author = {
            name: 'An error occurred!',
            icon_url: 'http://emojipedia-us.s3.amazonaws.com/cache/f4/63/f463408675b9437b457915713b9af46c.png'
          }
          e.add_field(
            name: 'Backtrace',
            value: "```#{error.backtrace.join("\n")}```"
          )
        end
      end
    end
  end
end
