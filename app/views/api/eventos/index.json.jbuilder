json.array!(@eventos) do |evento|
	json.id evento.id
	json.start evento.start_time
	json.end evento.end_time + 1.second
  json.title evento.paciente.full_name
  json.doctor evento.doctor_id
  json.paciente evento.paciente.full_name
  json.motivo evento.motivo
  json.color ['#e5412d','#f0ad4e','#428bca','#5cb85c','#5bc0de','#3c763d'][evento.doctor_id-1]
end