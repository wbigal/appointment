class ApiController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  skip_before_filter  :verify_authenticity_token

  rescue_from Exceptions::ParamsError, :with => :error_handling
  rescue_from ArgumentError, :with => :error_handling
	rescue_from ActiveRecord::RecordNotFound, :with => :error_handling
  private
  def error_handling(e)
    render json: {status: 'error',
										message: e.message,
										data:{}}, status: 400
  end
end
