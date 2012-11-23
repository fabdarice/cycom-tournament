class TournamentsController < ApplicationController
  respond_to :html
  
  def index
    @tournaments = Tournament.all

    respond_with(@tournaments)
  end

  def show
    @tournament = Tournament.find(params[:id])
    @users = @tournament.users_by_team if @tournament.is_in_team?

    respond_with(@tournament)
  end

  def new
    @tournament = Tournament.new
    @tournament.event_id = params[:event_id]
    @tournament.state = Tournament::WAITING

    respond_with(@tournament)
  end

  def edit
    @tournament = Tournament.find(params[:id])
  end

  def create
    @tournament = Tournament.create(params[:tournament])

    respond_with(@tournament)
  end

  def update
    @tournament = Tournament.find(params[:id])
    @tournament.update_attributes(params[:tournament])
    
    respond_with(@tournament)
  end

  def destroy
    @tournament = Tournament.find(params[:id])
    @tournament.destroy

    respond_with(:location => tournaments_path)
  end
  
  def start
    @tournament = Tournament.find(params[:id])
    
    if @tournament.rankings.size > 0
      @tournament.fill_ranking(1)
      redirect_to @tournament.rankings[0]
    else
      @tournament.fill_tree
      redirect_to @tournament.tree
    end
    @tournament.state = Tournament::RUNNING
  end
end
