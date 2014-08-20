class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  before_save :generar_full_name

  validates_presence_of :abreviacion, :apellido_paterno, :apellido_materno,
                        :nombres, :dni
  validates :abreviacion, length: { maximum: 6 }
  validates :nombres, length: { maximum: 250 }
  validates :apellido_paterno, length: { maximum: 250 }
  validates :apellido_materno, length: { maximum: 250 }
  
  validates :dni, :numericality => true
  validates_length_of :dni, :is => 8
  validates_uniqueness_of :dni

  validates_inclusion_of :admin, :in => [true, false]
  validates_inclusion_of :doctor, :in => [true, false]
  validates_inclusion_of :superadmin, :in => [true, false]

  validates_inclusion_of :sexo, :in => ['MASCULINO', 'FEMENINO'], allow_nil: true,
                          allow_blank:true  

  validate :color_format
  scope :doctors, -> { where(doctor: true) }
  scope :admins, -> { where(admin: true) }

	private
	def generar_full_name
    self.full_name = self.abreviacion + ' ' + self.apellido_paterno + ' ' + 
    								self.apellido_materno + ' ' + self.nombres
  end
  def color_format
    unless self.color =~ /^#(?:[0-9a-f]{3})(?:[0-9a-f]{3})?$/i
      errors[:color] << 'no es un color válido.'
    end
  end       
end
