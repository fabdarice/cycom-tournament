class ApplicationController < ActionController::Base
  helper_method :logged_in?, :admin?
  
  before_filter :check_cookie
  before_filter :set_user
  
  protect_from_forgery
  layout 'application'
  
  protected
  
  def logged_in?
    !session[:user_id].nil?
  end
  
  def admin?
    if logged_in?
      @logged_user ||= User.find(session[:user_id])
      @logged_user.admin?
    else
      false
    end
  end

  def check_admin
    if admin?
      true
    else
      redirect_to :root
    end 
  end
  
  def check_logged
    redirect_to :root if @current_user.nil?
  end
  
  def set_user
    if logged_in?
      @current_user = User.find(session[:user_id])
    end
  end
  
  # Assign a cookie to the user
  def assign_cookie_to_user(user)
    if user.cookie_hash.nil?
      user.cookie_hash = [Array.new(128) { rand(256).chr }.join].pack("m").chomp
      user.save(false)
    end

    cookie = UserCookie.new do |c|
      c.user_id = user.id
      c.cookie_id = [Array.new(128) { rand(256).chr }.join].pack("m").chomp
    end
    cookie.save(false)

    cookies[:user_id] = { :value => user.id.to_s, :expires => 15.days.from_now }
    cookies[:cookie_hash] = { :value => user.cookie_hash, :expires => 15.days.from_now }
    cookies[:cookie_id] = { :value => cookie.cookie_id, :expires => 15.days.from_now }
  end
  
  # Automatically logs in the user if he has a valid cookie
  def check_cookie
    if session[:user_id].nil?
      if cookies[:user_id] and cookies[:cookie_hash] and cookies[:cookie_id]
        user = User.find(cookies[:user_id])
        
        unless user.nil?
          # Check if the user has the good cookie hash
          if user.cookie_hash == cookies[:cookie_hash]
            user_cookie = user.cookies.select { |c| c.cookie_id == cookies[:cookie_id] }
            # If the cookie_id is wrong, an attack took place
            if user_cookie.empty?
              # In the case of an attack, we delete all the cookies for this user
              UserCookie.delete_all ["user_id = ?", user.id]

              # We also need to change the cookie_hash in order to protect the user
              user.cookie_hash = nil
              user.save(false)

              flash[:error] = I18n.t('session.attack')
            else
              # Everything is good, the user is authenticated and needs a new cookie
              session[:user_id] = user.id
              user_cookie[0].destroy
              assign_cookie_to_user user
            end
          else
            # Wrong cookie, could be an attack, so no messages
            cookies.delete :user_id
            cookies.delete :cookie_hash
            cookies.delete :cookie_id
          end

        end
      end
    end
  end
end
