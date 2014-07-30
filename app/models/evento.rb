class Evento < ActiveRecord::Base
	belongs_to :paciente
	validates :motivo, length: { maximum: 250 }
	validates :registrado_por, length: { maximum: 250 }
	validate :validate_timings
	validate :validate_on_same_day
	validate :validate_occupied_event
	validate :validate_paciente_exists

  #used for the principal calendar
	def self.all_in_range(**argv)
		start_date, end_date, doctor_id = Time.parse(argv[:start_date]),
																		 	Time.parse(argv[:end_date]),
																		 	argv[:doctor_id]
		events = where('start_time >= ? AND end_time <= ?', start_date, end_date)
		!doctor_id.blank? ? events.where(doctor_id: doctor_id) : events														 	
	end

	
	private
	def validate_paciente_exists
    errors[:paciente] << 'Ingresa un paciente registrado.' unless Paciente.find_by_id(self.paciente_id)
  end

	def validate_occupied_event
		query = 'doctor_id = :id AND (
								(start_time >= :starttime AND end_time <= :endtime) OR
                (start_time >= :starttime AND end_time > :endtime AND start_time <= :endtime) OR
                (start_time <= :starttime AND end_time >= :starttime AND end_time <= :endtime) OR
                (start_time <= :starttime AND end_time > :endtime))'
		unless Evento.where(query, starttime: self.start_time,
												endtime: self.end_time, id: self.doctor_id).count == 0
    	errors[:base] << 'Existe una cita durante esa hora.'
    end
	end
	def validate_timings
	  if start_time >= end_time
	    errors[:base] << "La hora de inicio debe se menor a la hora final."
	  end
	end
	#validates that an apointment start_time and end_time is on the same day
	def validate_on_same_day
		unless start_time.to_date == end_time.to_date
			errors[:base] << "Una cita no puede abarcar más de un día."
		end
	end		

end
