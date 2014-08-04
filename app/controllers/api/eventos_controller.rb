class Api::EventosController < ApiController
	def index
		@eventos = Evento.includes(:paciente,:doctor).all_in_range(doctor_id: params[:doctor_id],
																															start_date: params[:start],
																															end_date:params[:end])
	end
	def create
		evento = Evento.new(evento_params)
		if evento.save
			paciente = evento.paciente
			doctor = evento.doctor
			render json: {status: 'success',
										message: 'El evento fue creado correctamente.',
										data: {evento: {id: evento.id, start: evento.start_time,
																		end: evento.end_time + 1.second, title: paciente.full_name,
																		doctor: doctor.full_name, paciente: paciente.full_name,
																		motivo: evento.motivo,color: doctor.color}}}, status: :created
		else
			render json: {status: 'error',
									  message: 'No procesado.',
									  data: {errors: evento.errors.messages}}, status: 422
		end							
	end
	def destroy
		@eventos = Evento.destroy(params[:id])
		render json: {status: 'success',
									message: 'Evento eliminado.',
									data: {}}
	end
	private
	def evento_params
		parametros = params.require(:evento).permit(:paciente_id,:doctor_id,:motivo)
		parametros[:start_time] = Time.parse(params[:evento][:start])
		parametros[:end_time] = Time.parse(params[:evento][:end]) - 1.second
		return parametros
	end		
end
