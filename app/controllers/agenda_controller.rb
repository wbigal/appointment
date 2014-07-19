class AgendaController < WebController
	before_action :set_angular_appname
  def index
  end
  private
  def set_angular_appname
  	@angular_app_name = 'agenda'
  end
end
