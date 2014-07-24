class Api::EventosController < ApiController
	def index
		begin
			@eventos = Evento.all_in_range(doctor_id: params[:doctor_id],
																			start_date: params[:start],
																			end_date:params[:end])
			#render jBuider template
		rescue
			render json: {status: 'error',
										message: "Formato de parametros incorrecto.",
										data:{}}, status: 400
		end
	end
	def destroy
		begin
			@eventos = Evento.destroy(params[:id])
			render json: {status: 'success',
										message: 'Evento eliminado.',
										data: {}}
		rescue
			render json: {status: 'error',
										message: 'No procesado.',
										data: {}}, status: 400
		end
	end			
end
