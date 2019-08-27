class Users::OmniauthController < ApplicationController
  # facebook callback
  def facebook
    @user = User.create_from_provider_data(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user
      flash[:success] = "You have successfully signed in"
    else
      flash[:error] = 'There was a problem signing you in through Facebook. Please register or try signing in later.'
      redirect_to new_user_registration_url
    end
  end

  # github callback
  def github
    @user = User.create_from_provider_data(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user
      flash[:success] = "You have successfully signed in"
    else
      flash[:error] = 'There was a problem signing you in through Github. Please register or try signing in later.'
      redirect_to new_user_registration_url
    end
  end

  # google callback
  def google_oauth2
    @user = User.create_from_provider_data(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user
      flash[:success] = "You have successfully signed in"
    else
      flash[:danger] = 'There was a problem signing you in through Google. Please register or try signing in later.'
      redirect_to new_user_registration_url
    end
  end

  # twitter callback
  def twitter
    @user = User.create_from_provider_data(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user
      flash[:success] = "You have successfully signed in"
    else
      flash[:error] = 'There was a problem signing you in through Twitter. Please register or try signing in later.'
      redirect_to new_user_registration_url
    end
  end


  # failure callback
  def failure
    flash[:error] = 'There was a problem signing you in. Please register or try signing in later.'
    redirect_to new_user_registration_url
  end
end
