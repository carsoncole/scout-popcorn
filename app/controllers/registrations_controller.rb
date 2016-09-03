class RegistrationsController < Devise::RegistrationsController

  private

  def sign_up_params
    params.require(:scout).permit(:first_name, :last_name, :parent_first_name, :parent_last_name, :email, :password, :password_confirmation, :unit_id)
  end

  def account_update_params
    params.require(:scout).permit(:first_name, :last_name, :email, :parent_first_name, :parent_last_name,:password, :password_confirmation, :current_password)
  end
end