json.array!(@eventos) do |evento|
	json.id evento.id
	json.start evento.start_time
	json.end evento.end_time
  json.title evento.motivo
end
