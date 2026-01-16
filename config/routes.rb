Rails.application.routes.draw do
  resources :runs, only: [ :new, :create, :show ] do
    match :unlock, on: :member, via: [ :get, :post ]
  end

  root "runs#new"
end
