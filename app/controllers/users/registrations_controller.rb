class Users::RegistrationsController < Devise::RegistrationsController

  # This controller overrides the default Devise registrations controller to handle
  # the creation of a user with a specific `userable_type` (either `Artist` or `Client`).
  # It builds the resource based on the sign-up parameters and assigns a new `Artist` or `Client`
  # instance to the `userable` association. After saving the resource, it checks if the user is
  # persisted and redirects accordingly.

  def create
    build_resource(sign_up_params)

    if params[:user][:userable_type] == "Artist"
      resource.userable = Artist.create!
    elsif params[:user][:userable_type] == "Client"
      resource.userable = Client.create!
    end

    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        sign_up(resource_name, resource)
        redirect_to user_path(resource)
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
