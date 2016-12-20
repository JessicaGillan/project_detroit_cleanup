Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'food_stops#index'

  resources :food_stops, only: [:index, :show]
end
