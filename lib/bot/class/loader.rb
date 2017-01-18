#JSON Loader
def LoadJSON(ar, loc)
	if File.exist?(loc)
		begin
			ar = JSON.parse File.read loc
		rescue
			ar = Hash.new
		end
	else
		puts "No file #{loc} to load!"
	end
	return ar
end
#JSON Loader for Permissions
def LoadPermissions(ar,loc)
	if File.exist?(loc)
		begin
			ar = JSON.parse File.read loc
		rescue
			ar = Hash.new
		end
	else
		puts "You have not set up any permissions", "Please enter your user id to set admin permissions for your discord account"
		id = $stdin.gets.chomp.to_i
		ar[id] = {'id'=>id.to_i, 'lvl'=>999}
		File.open(loc, 'w') { |f| f.write ar.to_json }
		puts "Permissions saved!"
	end
	return ar
end