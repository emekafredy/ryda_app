class UsersController < ApplicationController
  before_action :authenticate_user
  before_action :set_user, only: [:profile, :update_phone_number]

  def profile
  end

  def update_phone_number
    @user = User.find(current_user.id) rescue not_found
    @user.update(phone_update_params)
    flash.notice = 'You have Updated your phone number'
    redirect_to profile_path
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = current_user rescue not_found
  end

  def phone_update_params
    params.require(:user).permit(:phone_number)
  end
end
