class TeamsController < ApplicationController
  respond_to :html
  
  def index
    @teams = Team.find(:all)

    respond_with(@users)
  end

  def show
    @team = Team.find(params[:id])
    @branches = Membership.user_branches(@team.id)

    respond_with(@teams)
  end

  def new
    @team = Team.new

    respond_with(@team)
  end

  def edit
    @team = Team.find(params[:id])
  end

  def create
    @team = Team.create(params[:team])

    respond_with(@team)
  end

  def update
    @team = Team.find(params[:id])
    @team.update_attributes(params[:team])
    
    respond_with(@team)
  end

  def destroy
    @team = Team.find(params[:id])
    @team.destroy

    respond_with(:location => teams_path)
  end
end
