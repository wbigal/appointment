class UsersController < ApplicationController
  load_and_authorize_resource
  #skip_authorize_resource :only => [:edit_password, :update_password, :mi_perfil]
	def index
    @angular_app_name ||= 'usersApp'
		@users = User.paginate(:page => params[:page], :per_page => 10).order('full_name')
  end
  def new
  	@user = User.new
  end
  def create
    parameters = user_params
    parameters[:password] = params[:user][:dni]
    parameters[:password_confirmation] = params[:user][:dni]
    @user = User.new(parameters)
    if @user.save
      redirect_to users_path, notice: 'Se registró correctamente el usuario.'
    else
      flash.now[:alert] = 'Hubo un problema. No se registró el usuario.'
      render action: 'new'      
    end 
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.superadmin && current_user == @user
      params[:user][:superadmin] = true
    end
    if @user.update(user_params)
      redirect_to users_path, notice: 'Se actualizó correctamente el usuario.'
    else
      flash.now[:alert] = 'Hubo un problema. No se pudo actualizar los datos.'
      render action: 'edit'
    end
  end

  def reset_password
    @user = User.find(params[:user_id])
    if current_user.id != @user.id
      @user.update_attributes(:password => @user.dni, :password_confirmation => @user.dni)
      redirect_to users_path, notice: 'Se ha reseteado correctamente.'
    else
      redirect_to users_path, alert: "Hubo un problema. No puedes resetear tu propio usuario"
    end
  end
  private

  def user_params
    params.require(:user).permit(:dni, :email, :apellido_paterno, :apellido_materno, :nombres, :sexo,
    													 :abreviacion, :superadmin, :admin, :doctor, :color, :deshabilitado)
  end
end
