# Used to send reminders via dm
def reminder_dm(time, id, tag, message)
  Bot::SCHEDULER.at time, tags: [id.to_s, tag] do
    Bot::BOT.user(id).pm(message)
  end
end

# Used to send reminders via a channel
def reminder_channel(time, channel, tag, message)
  Bot::SCHEDULER.at time, tags: [channel.to_s, tag] do
    Bot::BOT.channel(channel).send_message message
  end
end
