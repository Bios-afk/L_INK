Rails.application.routes.draw do
  devise_for :users
  root to: "artists#index"

  resources :artists, except: [:index], only: [:show] do
    resources :quote_requests, only: [:new, :create]
  end

  resources :quote_requests, only: [:show, :index] do
    member do
      patch :accept
      patch :reject
    end
    resources :bookings, only: [:new, :create]
  end
  resources :clients, only: [:show]

  resources :message_feeds, only: [:index, :show, :destroy] do
    resources :messages, only: [:create]
  end
end
