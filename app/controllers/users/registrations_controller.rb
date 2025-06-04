class Users::RegistrationsController < Devise::RegistrationsController

  def create
    build_resource(sign_up_params)

    # Création du bon type de profil selon le champ userable_type
    if params[:user][:userable_type] == "Artist"
      resource.userable = Artist.create(
        address: "Indiquez votre adresse pro pour la géolocalisation", # Adresse temporaire pour éviter les erreurs de validation
      )
    elsif params[:user][:userable_type] == "Client"
      resource.userable = Client.create!
    end


    resource.save
    yield resource if block_given?

    if resource.persisted?
      if resource.active_for_authentication?
        sign_up(resource_name, resource)

        # ✅ Redirection personnalisée selon le type de userable
        # "redirect_to edit_artist_path(resource.userable)" redirige vers le formulaire de complétion du profil artiste.
        # "and return" est important pour stopper le traitement et éviter une double redirection.
        if resource.userable_type == "Artist"
          redirect_to edit_artist_path(resource.userable) and return
        else
          redirect_to user_path(resource) and return
        end
      else
        expire_data_after_sign_in!
        redirect_to root_path, notice: "Inscription réussie. En attente d'activation."
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end
end
