json.array!(@pacientes) do |paciente|
	json.extract! paciente, :id, :dni, :full_name
end