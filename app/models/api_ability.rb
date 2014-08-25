class ApiAbility
  include CanCan::Ability
  def initialize(user)
    user = user || User.new
    if user.admin?
      can :index, :doctors

      can :index, :eventos
      can :create, :eventos
      can :destroy, :eventos
      
      can :buscar_pacientes, :pacientes
    end
    if user.doctor?
      can :index, :doctors

      can :index, :eventos

      can :buscar_pacientes, :pacientes
    end
    if user.superadmin?
      can :index, :users
      can :create, :users
      can :show, :users
      can :update, :users
      can :reset_password, :users
    end
  end
end
