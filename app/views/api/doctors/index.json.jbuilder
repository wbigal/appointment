json.array!(@doctors) do |doctor|
	json.id doctor.id
	json.full_name doctor.full_name
	json.color doctor.color
end