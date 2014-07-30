class Api::EventosController < ApiController
	def index
		begin
			@eventos = Evento.includes(:paciente).all_in_range(doctor_id: params[:doctor_id],
																			start_date: params[:start],
																			end_date:params[:end])
			#render jBuider template
		rescue
			render json: {status: 'error',
										message: "Formato de parametros incorrecto.",
										data:{}}, status: 400
		end
	end
	def create
		begin
			#doctor = Doctor.find(params[:evento][:doctor_id])
			evento = Evento.new(paciente_id: params[:evento][:paciente_id],
												 	doctor_id: params[:evento][:doctor_id],
													start_time: Time.parse(params[:evento][:start]),
													end_time: Time.parse(params[:evento][:end]) - 1.second,
													motivo: params[:evento][:motivo])
			if evento.save
				paciente = evento.paciente
				render json: {status: 'success',
											message: 'El evento fue creado correctamente.',
											data: {evento: {id: evento.id, start: evento.start_time,
																			end: evento.end_time + 1.second, title: paciente.full_name,
																			doctor: evento.doctor_id, paciente: paciente.full_name,
																			motivo: evento.motivo,color: ['#e5412d','#f0ad4e',
																			'#428bca','#5cb85c','#5bc0de','#3c763d'][evento.doctor_id-1]}}}
			else
				render json: {status: 'error',
										message: 'No procesado.',
										data: {errors: evento.errors.messages}}, status: 422
			end
		rescue
			render json: {status: 'error',
										message: 'No procesado.',
										data: {}}, status: 400
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
