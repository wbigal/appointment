class Ability
  include CanCan::Ability
  def initialize(user)
    user = user || User.new
    if user.admin?
      can :index, :agenda
      can :index, :principal

      can :destroy, :api_eventos
      can :create, :api_eventos
    end
    if user.doctor?
      can :index, :agenda
      can :index, :principal
    end
    if user.superadmin?
      can :index, :agenda
      can :index, :principal

      can :index, User
      can :new, User
      can :create, User
      can :edit, User
      can :update, User
      can :reset_password, User
    end
  end
end
#common for the 3
#can :index, :agenda
#can :index, :principal
