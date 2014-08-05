class Api::DoctorsController < ApiController
	def index		
		@doctors = User.doctors.order('full_name')
	end
end
