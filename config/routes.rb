Rails.application.routes.draw do
  resources :runs, only: [ :new, :create, :show ]
  root "runs#new"
end
