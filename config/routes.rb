Rails.application.routes.draw do
  post 'sign_up', to: 'users#sign_up'
  post 'login', to: 'users#login'

  resources :tickets do
    post :clone, on: :member
  end
end
