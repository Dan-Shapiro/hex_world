Rails.application.routes.draw do
  resources :runs, only: [ :new, :create, :show ] do
    match :unlock, on: :member, via: [ :get, :post ]
    post :end_turn, on: :member
    post :cast, on: :member
  end

  root "runs#new"
end
