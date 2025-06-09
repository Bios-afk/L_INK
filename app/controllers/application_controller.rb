class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    user_path(resource)
    cookies.signed[:user_id] = {
    value: resource.id,
    httponly: true, # sécurise le cookie, non accessible par JS
    expires: 1.week.from_now
  }

  end

  protected

  # Autoriser le champ `userable_type` lors de l'inscription
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:userable_type, :pseudo, :first_name, :last_name])
  end
end
