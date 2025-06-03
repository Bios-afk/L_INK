Rails.application.routes.draw do
  # Utilisation d’un contrôleur personnalisé pour l'inscription Devise
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

  # Route pour afficher un profil utilisateur public
  resources :users, only: [:show, :edit, :update]

  # Page d'accueil
  root to: "artists#index"

  # Routes pour artistes
  resources :artists, only: [:show, :edit, :update] do
    resources :devis, only: [:new, :create]
  end

  # Routes pour devis
  resources :devis, only: [:show] do
    resources :bookings, only: [:new, :create]
  end

  # Route pour les clients
  resources :clients, only: [:show]

  # Messages
  resources :message_feeds, only: [:index, :show, :destroy] do
    resources :messages, only: [:create]
  end
end
