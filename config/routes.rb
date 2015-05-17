Rails.application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: 'callbacks' }

  resources :tic_tac_toe_games
  root 'tic_tac_toe_games#index'

end