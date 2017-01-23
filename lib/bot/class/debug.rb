def debug(line, message)
	if $settings['debug']
		puts "[DEBUG][#{line}]#{message}"
	end
end
