class GroupsController < ApplicationController
  respond_to :html
  
  def show
    @group = Group.find(params[:id])

    respond_with(@group)
  end

  def generate_games
    group = Group.find(params[:id])

    group.games.delete_all
    group.create_games(group.ranking.games_number)
    redirect_to :back
  end
end
