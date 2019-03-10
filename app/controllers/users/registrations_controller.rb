class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
        :account_update,
        keys: [
            :email, :username, :password, :password_confirmation, :current_password,
            :avatar, :description, :city,
            skills_attributes: [:id, :level, :sport_id, :_destroy]
        ]
    )
    devise_parameter_sanitizer.permit(
        :sign_up,
        keys: [
            :email, :username, :password, :password_confirmation
        ]
    )
  end

  def update_resource(resource, params)
    resource.update_without_password(params.except("current_password"))
  end

end
