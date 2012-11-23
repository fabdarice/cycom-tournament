class UsersController < ApplicationController
  #before_filter :check_admin, :except => [:index, :show, :new, :create]
  respond_to :html
  
  def index
    @users = User.all
    
    respond_with(@users)
  end

  def show
    @user = User.find(params[:id])
    @branches = Membership.team_branches(@user.id)
    #@orders = @user.orders

    respond_with(@user)
  end

  def new
    @user = User.new

    respond_with(@user)
  end

  def edit
    @user = User.find(params[:id])
    @user.password_confirmation = @user.password
  end

  def create
    @user = User.new(params[:user])
    if User.all.size == 0
      @user.admin = 1
    end
    session[:user_id] = @user.id if @user.save
    
    respond_with(@user)
  end

  def update
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])

    respond_with(@user)
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_with(:location => users_path)
  end
  
  #def manage_admin
  #  @users = User.find(:all, :conditions => { :admin => 1 })
  #end
  
  #def remove_admin
  #  @user = User.find(params[:id])
  #  @user.update_attribute(:admin, false)
  #  redirect_to :action => "manage_admin"
  #end
  
  #def add_admin
  #  @users = User.find(:all, :conditions => { :admin => 0 })
  #end
end
