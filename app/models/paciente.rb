class Paciente < ActiveRecord::Base
	has_many :eventos
	before_validation :generar_full_name
	private
	def generar_full_name
    self.full_name = self.apellido_paterno + ' ' + self.apellido_materno + ' ' +
                     self.nombres
  end
end
