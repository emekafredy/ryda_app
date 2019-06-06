Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth' }
  get 'welcome/index'
  get 'offers/all'
  get 'users/profile', :to => 'users#profile', :as => :profile
  put 'users/profile', :to => 'users#update_phone_number', :as => :update_phone_number
  get 'requests/completed_requests', :to => 'requests#completed_requests', :as => :completed_requests
  get 'offers/ride_matches'
  get 'offers/ride_matches/:id', :to => 'offers#match_details', :as => :ride_details
  put 'offers/ride_matches/:id', :to => 'offers#join_ride', :as => :join_ride
  get 'offers/my_booked_ride'
  put 'offers/my_booked_ride/cancel', :to => 'offers#cancel_ride', :as => :cancel_ride
  put 'offers/my_booked_ride/complete', :to => 'offers#complete_request', :as => :complete_request
  put 'offers/:id', :to => 'offers#start_ride', :as => :start_ride
  put 'offers/:id/complete', :to => 'offers#complete_ride', :as => :complete_ride
  get 'offers/completed_offers', :to => 'offers#completed_offers', :as => :completed_offers
  resources :requests
  resources :offers
  root to: 'welcome#index'
end
