class UsersController < ApplicationController
  load_and_authorize_resource
	def index
    @angular_app_name ||= 'usersApp'
  end
end
