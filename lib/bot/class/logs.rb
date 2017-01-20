def command_log(command_name, user_name)
	unless $logs.has_key?('commands')
		$logs['commands'] = {}
	end
	unless $logs['commands'].has_key?(command_name)
		$logs['commands'][command_name] = 0
	end
	$logs['commands'][command_name] += 1
	puts "[#{Time.now.strftime("%d %a %y | %H:%M:%S")}] #{user_name}: CMD: #{command_name}"
end

def mute_log(channel_id)
	unless $logs.has_key?('muted')
		$logs['muted'] = {}
	end
	unless $logs['muted'].has_key(channel_id.to_s)
		$logs['muted'][channel_id.to_s] = [Time.now]
	else
		$logs['muted'][channel_id.to_s].push(Time.now)
	end
	puts "[#{Time.now.strftime("%d %a %y | %H:%M:%S")}] BOT has been muted in #{channel_id}"
end