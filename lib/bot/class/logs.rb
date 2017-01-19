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