ClinicasLibres::Application.routes.draw do
  devise_for :users
  match 'agenda', to: 'agenda#index', as: 'agenda', via: 'get'
  root "principal#index"

  namespace :api, defaults: {format: 'json'} do
    resources :eventos, except: [:update,:new,:edit,:show]
    resources :doctors, except: [:update,:new,:edit]
    scope '/buscar' do
    	match '/pacientes',to: 'pacientes#buscar_pacientes',as:'buscar_pacientes', via: 'get'
    end
  end
end
