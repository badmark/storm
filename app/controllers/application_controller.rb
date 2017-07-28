class ApplicationController < ActionController::Base
  protect_from_forgery(with: :exception)

  layout(:by_resource)

  before_action(:configure_permitted_parameters, if: :devise_controller?)
  before_action(:configure_initial_account)

  private

  def by_resource
    guest? ? 'unauthenticated' : 'application'
  end

  def guest?
    devise_controller? && !user_signed_in?
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password])
  end

  def configure_initial_account
    return unless InitialAccountSetup.new(current_user, request.path).required?

    flash[:info] = 'Welcome to Storm! Let\'s get your app setup.'
    redirect_to(new_user_registration_path)
  end
end
