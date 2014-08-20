class AgendaController < ApplicationController
	before_action :set_angular_appname
	authorize_resource :class => false 	
  def index
  end
  private
  def set_angular_appname
  	@angular_app_name ||= 'agenda'
  end
end
