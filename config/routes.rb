Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth' }
  get 'welcome/index'
  get 'offers/all'
  get 'offers/ride_matches'
  get 'offers/ride_matches/:id', :to => 'offers#match_details', :as => :ride_details
  put 'offers/ride_matches/:id', :to => 'offers#join_ride', :as => :join_ride
  get 'offers/my_booked_ride'
  put 'offers/my_booked_ride', :to => 'offers#cancel_ride', :as => :cancel_ride
  root 'welcome#index'

  authenticated :user do
    resources :requests
    resources :offers
  end
end
