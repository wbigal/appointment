ClinicasLibres::Application.routes.draw do
  devise_for :users,:skip => :registrations
  match 'agenda', to: 'agenda#index', as: 'agenda', via: 'get'
  
  
  match '/users', to: 'users#index', as:'users', via: 'get'
  match '/users/*path', to: 'users#index', via: 'get'
  namespace :api, defaults: {format: 'json'} do
    resources :eventos, except: [:update,:new,:edit,:show]
    resources :doctors, except: [:update,:new,:edit]
    resources :users, except: [:new,:edit] do
      match '/reset_password', to: 'users#reset_password', as: "reset_password", via: 'post'
    end
    scope '/buscar' do
    	match '/pacientes',to: 'pacientes#buscar_pacientes',as:'buscar_pacientes', via: 'get'
    end
  end

  root "principal#index"
end
