class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  before_save :generar_full_name

  scope :doctors, -> { where(doctor: true) }
  scope :admins, -> { where(admin: true) }

	private
	def generar_full_name
    self.full_name = self.abreviacion + ' ' + self.apellido_paterno + ' ' + 
    								self.apellido_materno + ' ' + self.nombres
  end       
end
