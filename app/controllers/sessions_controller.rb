class SessionsController < ApplicationController
  # Login method
  def create
    if params[:nickname].nil? or params[:password].nil?
      flash[:error] = I18n.t('session.bad_login_info')
    else
      user = User.find_by_nickname(params[:nickname])
      if user.nil? or !user.password_is? params[:password]
        flash[:error] = I18n.t('session.bad_login_info')
      else
        session[:user_id] = user.id

        flash[:valid] = I18n.t('session.ok')

        assign_cookie_to_user user if params[:remember]
      end
    end

    redirect_to :back
  end

  # Logout method
  def destroy
    session[:user_id] = nil
    
    # FIXME: buvette
    #session[:order] = nil

    if cookies[:user_id] and cookies[:cookie_id]
      UserCookie.delete_all ["user_id = ? AND cookie_id = ?", cookies[:user_id], cookies[:cookie_id]]

      cookies.delete :user_id
      cookies.delete :cookie_hash
      cookies.delete :cookie_id
    end

    flash[:valid] = I18n.t('session.logout')
    redirect_to :back
  end
end
