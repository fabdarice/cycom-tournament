class RankingsController < ApplicationController
  respond_to :html
  
  def index
    @rankings = Ranking.find(:all)

    respond_with(@rankings)
  end

  def show
    @ranking = Ranking.find(params[:id])

    respond_with(@ranking)
  end

  def new
    @ranking = Ranking.new
    @ranking.tournament_id = params[:tournament_id]
    @ranking.round = params[:round]

    respond_with(@ranking)
  end

  def edit
    @ranking = Ranking.find(params[:id])
  end

  def create
    @ranking = Ranking.create(params[:ranking])

    respond_with(@ranking)
  end

  def update
    @ranking = Ranking.find(params[:id])
    @ranking.update_attributes(params[:ranking])
    
    respond_with(@ranking)
  end

  def destroy
    @ranking = Ranking.find(params[:id])
    @ranking.destroy

    respond_with(:location => rankings_path)
  end
  
  def generate_games
      ranking = Ranking.find(params[:id])
      groups = ranking.groups
  
      groups.each do |group|
        group.games.delete_all
        group.create_games(ranking.games_number)
      end
      redirect_to :back
  end
end
