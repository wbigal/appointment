class Api::DoctorsController < ApiController
	def index
		begin
			sleep 1
			render json: [{id:1, full_name: 'Dr. Juan Aliaga Robles'},
										{id:2, full_name: 'Odon. Rogrigo Palacios Welving'},
										{id:3, full_name: 'Dr. Lionel Messi Frionel'},
										{id:4, full_name: 'Dr. Diego Armando Maradona'},
										{id:5, full_name: 'Odon. Sofia Franco Savira'},
										{id:6, full_name: 'Odon. Manuel Heredia Chavez'}]
		rescue
			render json: {error: "Formato de parametros incorrecto."}, status: 400
		end
	end
end
