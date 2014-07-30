# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#seed for events
#creation of enfermeras
1.upto(100) do |index|
	Paciente.create(apellido_paterno:Faker::Name.last_name,
									apellido_materno:Faker::Name.last_name,
									nombres: Faker::Name.first_name,
									fecha_nacimiento: Date.today-rand(20000),
									sexo:['Masculino','Femenino'][rand(0..1)],
									domicilio: Faker::Address.street_address,
									lugar_nacimiento:"#{Faker::Address.state}, #{Faker::Address.country}",
									telefono_fijo:Faker::PhoneNumber.cell_phone,
									telefono_celular:Faker::PhoneNumber.cell_phone,
									estado_civil:['Soltero','Casado','Divorciado'][rand(0..2)],
									ocupacion:Faker::Name.title,
									recomendado_por:Faker::Name.name,
									dni: 1.upto(8).map{|d| rand(0..9)}.join)
end
#creation of eventos
now = Time.now
min = now - 1.month
max = now + 1.month
1.upto(6) do |index|
	1.upto(50) do |val|
		inicial_time = rand(min..max).change(min: [0,30][rand(0..1)])
		end_time = inicial_time + [30,60][rand(0..1)].minutes
		Evento.create(doctor_id: index, paciente_id: Paciente.find(:first, :offset =>rand(100)).id,
								motivo: Faker::Lorem.sentence(2,4),
								start_time: inicial_time, end_time: end_time)
	end	
end

