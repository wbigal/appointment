json.array!(@eventos) do |evento|
	json.id evento.id
	json.start evento.start_time
	json.end evento.end_time + 1.second
  json.title evento.paciente.full_name
  json.doctor evento.doctor.full_name
  json.paciente evento.paciente.full_name
  json.motivo evento.motivo
  json.color evento.doctor.color
end