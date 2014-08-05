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
    elsif user.doctor?
      can :index, :doctors

      can :index, :eventos

      can :buscar_pacientes, :pacientes
    end
  end
end
