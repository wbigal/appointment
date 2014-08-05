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
  end
end
