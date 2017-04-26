Rails.application.routes.draw do

  root 'games#new'

  resources :games, only: [:new, :create, :show]

end
