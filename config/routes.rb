ClinicasLibres::Application.routes.draw do
  match 'agenda', to: 'agenda#index', as: 'agenda', via: 'get'
  root "principal#index"

  namespace :api, defaults: {format: 'json'} do
    resources :eventos, except: [:update,:new,:edit]
    resources :doctors, except: [:update,:new,:edit]
  end
end
