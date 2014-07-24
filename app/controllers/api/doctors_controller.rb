class Api::DoctorsController < ApiController
	def index
		begin
			sleep 1
			render json: [{id:1, full_name: 'Juan Aliaga'},
										{id:2, full_name: 'Rogrigo Palacios Welving'},
										{id:3, full_name: 'Lionel Messi'},
										{id:4, full_name: 'Diego Armando Maradona'},
										{id:5, full_name: 'Sofia Franco'},
										{id:6, full_name: 'Manuel Heredia Chavez'}]
		rescue
			render json: {error: "Formato de parametros incorrecto."}, status: 400
		end
	end
end
