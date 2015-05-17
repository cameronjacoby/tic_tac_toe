Rails.application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: 'callbacks' }

  resources :users, except: [:new, :create, :destroy]
  resources :games, only: [:create, :show] do
    member do
      put :play
    end
  end
  
  root 'users#index'

end