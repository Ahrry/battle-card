Rails.application.routes.draw do

  root 'games#new'

  resources :games, only: [:new, :create, :show] do
    get 'new_user', on: :member
    post 'add_user', on: :member
    resources :hands, only: [] do
      post 'distribute_cards', on: :collection
    end
    resources :game_turns, only: [:create] do
      put 'battle', on: :member
    end
  end

end
