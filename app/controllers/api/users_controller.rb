class Api::UsersController < ApiController
	def index
		@users = User.paginate(:page => params[:page], :per_page => 5).order('full_name')
	end
	def create		
    parameters = user_params
    parameters[:password] = params[:user][:dni]
    parameters[:password_confirmation] = params[:user][:dni]
		user = User.new(parameters)
		if user.save
			render json: {status: 'success',
										message: 'El usuario fue creado correctamente.',
										data: {user: {id: user.id}}}, status: :created
		else
			render json: {status: 'error',
									  message: 'No procesado.',
									  data: {errors: user.errors.messages}}, status: 422
		end							
	end
  def show
    @user = User.find(params[:id])
  end
	def update
		user = User.find(params[:id])
		if user.superadmin && current_user == user
      params[:user][:superadmin] = true
    end
		if user.update_attributes(user_params)
			render json: {status: 'success',
										message: 'El usuario fue actualizado correctamente.',
										data: {user: {id: user.id}}}, status: 200
		else
			render json: {status: 'error',
									  message: 'No procesado.',
									  data: {errors: user.errors.messages}}, status: 422
		end
	end
	def reset_password
    user = User.find(params[:user_id])
    if current_user.id != user.id
      user.update_attributes(:password => user.dni, :password_confirmation => user.dni)
      render json: {status: 'success',
										message: 'Se cambio el password del usuario.',
										data: {}}, status: 200
    else
      render json: {status: 'error',
										message: 'No puedes resetear tu propio password.',
										data: {}}, status: 422
    end
  end
	private
	def user_params
		params.require(:user).permit(:dni, :email, :apellido_paterno,
															 :apellido_materno, :nombres, :sexo,
    													 :abreviacion, :superadmin, :admin,
    													 :doctor, :color, :deshabilitado)	
	end
end
