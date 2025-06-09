Rails.application.routes.draw do
  # Utilisation d’un contrôleur personnalisé pour l'inscription Devise
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

  # Page d'accueil
  root to: "artists#index"

  # Route pour afficher un profil utilisateur public
  resources :users, only: [:show, :edit, :update]

  # Route pour les clients
  resources :artists, only: [:index, :show, :edit, :update] do
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

  # Messages
  resources :message_feeds, only: [:index, :show, :destroy] do
    resources :messages, only: [:index, :create]
  end
  
  # Route Post pour la geolocalisation
  post 'users/set_location', to: 'users#set_location'
end
