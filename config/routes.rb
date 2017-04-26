Rails.application.routes.draw do

  root 'games#new'

  resources :games, only: [:new, :create, :show] do
    get 'new_user', on: :member
  end

end
