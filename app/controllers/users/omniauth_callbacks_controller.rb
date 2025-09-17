# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end
  def google_oauth2
    auth = request.env["omniauth.auth"]
    social_profile = SocialProfile.find_by(provider: auth.provider, uid: auth.uid)

    if social_profile.present?
      @user = social_profile.user
    else
      User.transaction do
        @user = User.new(name: auth.info.name || nil)
        @user.social_login = true
        @user.save!
        @user.social_profiles.create!(provider: auth.provider, uid: auth.uid)
      end
    end

    sign_in_and_redirect @user, event: :authentication
    set_flash_message(:notice, :success, kind: 'google') if is_navigational_format?
  rescue => e
    redirect_to new_user_session_path, alert: "Googleログイン処理に失敗しました。"
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
