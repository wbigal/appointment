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
colores = %w[#69D2E7 #A7DBD8 #E0E4CC #F38630 #FA6900
  		 		#ECD078 #D95B43 #C02942 #542437 #53777A #556270
			 		#4ECDC4 #C7F464 #FF6B6B #C44D58 #547980 #45ADA8
			 		#9DE0AD #CBE86B #FF4E50 #FC913A #F9D423 #EDE574]
color = colores[rand(0..22)]
#creation of 1 Admin user
user = User.create(password: '1234abcd', password_confirmation:'1234abcd', email: 'chences@hotmail.com',
						admin: true, apellido_paterno: 'Paez', apellido_materno:'Chavez', nombres:'Wenceslao',
						abreviacion: 'Lic.', dni:'46399081', color: color, superadmin:true, doctor:false)
#creation of a mix Admin-Doctor user
color = colores[rand(0..22)]
User.create(password: '1234abcd', password_confirmation:'1234abcd', email: 'jujuy@hotmail.com',
						admin: true, doctor:true, apellido_paterno: 'Oltra', apellido_materno:'Suerez', nombres:'Luis',
						abreviacion: 'Dr.', dni:'10203040', color: color, superadmin:false)
#Creation of 10 Doctors
1.upto(10).each do |index|
	name = Faker::Name.first_name
	color = colores[rand(0..22)]
	User.create(password: '1234abcd', password_confirmation:'1234abcd',
						 email: Faker::Internet.email(name),doctor:true, admin:false, superadmin:false,
						 apellido_paterno: Faker::Name.last_name, apellido_materno: Faker::Name.last_name,
						 nombres: name,sexo: ['MASCULINO','FEMENINO'][rand(0..1)], abreviacion: ['Dr.','Odon.'][rand(0..1)],
						 dni: 1.upto(8).map{|d| rand(0..9)}.join, color: color)
end
#creation of eventos
now = Time.now
min = now - 1.month
max = now + 1.month
1.upto(10) do |index|
	1.upto(50) do |val|
		inicial_time = rand(min..max).change(min: [0,30][rand(0..1)])
		end_time = inicial_time + [30,60][rand(0..1)].minutes
		Evento.create(doctor_id: User.doctors.find(:first, :offset =>rand(11)).id, paciente_id: Paciente.find(:first, :offset =>rand(100)).id,
								motivo: Faker::Lorem.sentence(2,4),
								start_time: inicial_time, end_time: end_time - 1.second)
	end	
end

