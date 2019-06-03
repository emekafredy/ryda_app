Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth' }
  get 'welcome/index'
  get 'offers/all'
  get 'offers/ride_matches'
  root 'welcome#index'

  authenticated :user do
    resources :requests
    resources :offers
  end
end
