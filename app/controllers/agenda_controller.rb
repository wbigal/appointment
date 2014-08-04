class AgendaController < WebController
	before_action :set_angular_appname
  def index
  	@hola = 'chau'
  end
  private
  def set_angular_appname
  	@angular_app_name ||= 'agenda'
  end
end
