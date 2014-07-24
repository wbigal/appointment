# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#seed for events
now = Time.now
min = now - 1.month
max = now + 1.month
1.upto(6) do |index|
	1.upto(100) do |val|
		inicial_time = rand(min..max).change(min: [0,30][rand(0..1)])
		end_time = inicial_time + [30,60][rand(0..1)].minutes
		Evento.create(doctor_id: index, paciente_id: rand(1..10),
								motivo: Faker::Lorem.sentence(2,4),
								start_time: inicial_time, end_time: end_time)
	end	
end

