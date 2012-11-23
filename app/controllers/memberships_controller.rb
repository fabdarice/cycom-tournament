class MembershipsController < ApplicationController
  before_filter :logged_in?

  # Joining team
  def create
    team = Team.find(params[:id])

    # Is the user already in this team and in this branch ?
    if Membership.where("team_id = ? AND user_id = ? AND branch_id = ?",
                        team.id, session[:user_id], params[:branch_id]).first
      flash[:error] = I18n.t('membership.already')
      redirect_to :back
    else
      # Check if this is the good password and create the membership
      if team.password_is? params[:password]
        m = Membership.new
        m.user_id = session[:user_id]
        m.team_id = team.id
        m.branch_id = params[:branch_id]
        if m.save
          flash[:valid] = I18n.t('membership.ok')
        else
          flash[:error] = I18n.t('membership.no_branch')
        end
        redirect_to team
      else
        flash[:error] = I18n.t('membership.bad_password')
        redirect_to :back
      end
    end
  end

  # Leave team
  def destroy
    m = Membership.find(params[:id])
    
    if m.user_id = session[:user_id]
      m.destroy
      flash[:valid] = I18n.t('membership.destroy')
    end
    
    redirect_to :back
  end
end
