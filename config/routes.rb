Rails.application.routes.draw do
  devise_for :users
  root to: "artists#index"

  resources :artists, except: [:index], only: [:show] do
    resources :devis, only: [:new, :create]
  end

  resources :devis, only: [:show] do
    resources :bookings, only: [:new, :create]
  end

  resources :clients, only: [:show]

  resources :message_feeds, only: [:index, :show, :destroy] do
    resources :messages, only: [:create]
  end
end
