class Users::RegistrationsController < Devise::RegistrationsController

  def create
    puts "🎯 CONTROLEUR PERSONNALISÉ UTILISÉ"

     # 👉 Vérification reCAPTCHA AVANT toute création
    puts "🔍 reCAPTCHA score en cours de vérification..."
    recaptcha_valid = verify_recaptcha(action: 'signup', minimum_score: Rails.env.development? ? 0.1 : 0.5)
    puts "📊 reCAPTCHA Score : #{request.env['recaptcha.score']}"
    puts "🔎 reCAPTCHA ENV : #{request.env.select { |k, _| k.include?('recaptcha') }}"

    puts "🔒 reCAPTCHA valide ? #{recaptcha_valid}"
    unless recaptcha_valid
      puts "⚠️ reCAPTCHA invalide. Redirection vers le formulaire."
      # flash[:alert] = "Captcha invalide, veuillez réessayer."
      build_resource(sign_up_params)
      render :new and return
    end

    # 🔧 Création du User (sans le sauvegarder encore)
    build_resource(sign_up_params)

    # 🎭 Création du profil associé (Artist ou Client)
    case params[:user][:userable_type]
    when "Artist"
      artist = Artist.create(address: "")
      unless artist.persisted?
        # flash[:alert] = "Erreur lors de la création du profil artiste : #{artist.errors.full_messages.join(', ')}"
        render :new and return
      end
      resource.userable = artist

    when "Client"
      client = Client.create
      unless client.persisted?
        # flash[:alert] = "Erreur lors de la création du profil client : #{client.errors.full_messages.join(', ')}"
        render :new and return
      end
      resource.userable = client

    else
      # flash[:alert] = "Type d'utilisateur invalide."
      render :new and return
    end

    # 💾 Sauvegarde du User (et du userable lié)
    resource.save
    yield resource if block_given?

    puts "👮‍♂️ ERREURS À L'INSCRIPTION : #{resource.errors.full_messages}"

    if resource.persisted?
      if resource.active_for_authentication?
        sign_up(resource_name, resource)

        # 🔁 Redirection personnalisée selon le type
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

  private

  def sign_up_params
    params.require(:user).permit(
      :email,
      :password,
      :password_confirmation,
      :first_name,
      :last_name,
      :pseudo,
      :userable_type,
      category_ids:[],
    )
  end



end
