def debug(line, message)
	if $debug
		puts "[DEBUG][#{line}]#{message}"
	end
end
