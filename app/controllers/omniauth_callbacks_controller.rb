class OmniauthCallbackController < Devise::OmniauthCallbackController
  def google_oauth2
    @user = User.find_for_google_oauth2(request.env["ominiauth.auth"].provider, request.env["ominiauth.auth"].uid, request.env["omniauth.auth"].extra.raw_info.name, request.env["omniauth.auth"].info.email, current_user)

    if @user.persisted?
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
      sign_in_and_redirect @user, event: :authentication
    else
      session['devise.google_data'] = request.env['omniauth.auth'].except(:extra)
      redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
    end
  end
end
