def load_json(file_location)
  if File.exist?(file_location)
    begin
      ar = {}
      ar = JSON.parse File.read file_location
    rescue
      ar = {}
    end
  else
    ar = {}
  end
  ar
end
