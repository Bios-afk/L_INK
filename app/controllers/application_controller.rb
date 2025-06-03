class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # Autoriser le champ `userable_type` lors de l'inscription
    devise_parameter_sanitizer.permit(:sign_up, keys: [:userable_type])
  end
end
