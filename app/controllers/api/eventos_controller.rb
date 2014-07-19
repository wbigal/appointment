class Api::EventosController < ApiController
	def index
		begin
			sleep 2
			@eventos = Evento.all_in_range(doctor_id: params[:doctor_id],
																			start_date: params[:start],
																			end_date:params[:end])
		rescue
			render json: {error: "Formato de parametros incorrecto."}, status: 400
		end
	end
end
