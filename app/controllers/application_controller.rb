class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception  
  before_action :authenticate_user!
  before_action :set_server_date
  layout 'web'
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path
  end  
  private
  def set_server_date
  	@server_date = Date.today.to_s
  end
end
