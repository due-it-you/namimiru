# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include Devise::Controllers::Rememberable

  skip_before_action :authenticate_user!
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end
  def google_oauth2
    auth = request.env["omniauth.auth"]
    @user = User.from_google_oauth(auth)

    remember_me(@user)

    sign_in_and_redirect @user, event: :authentication
    set_flash_message(:notice, :success, kind: "google") if is_navigational_format?
  rescue => e
    flash[:alert] = "Googleログイン処理に失敗しました。"
    redirect_to new_user_session_path and return
  end

  # More info at:
  # https://github.com/heartcombo/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end
