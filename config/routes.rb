ClinicasLibres::Application.routes.draw do
  match 'agenda', to: 'agenda#index', as: 'agenda', via: 'get'
  root "principal#index"
end
