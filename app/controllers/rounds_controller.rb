class RoundsController < ApplicationController
  # Hack pour les formulaires Ajax pour la modification des scores.
  skip_before_filter :verify_authenticity_token

  def edit
    @round = Round.find(params[:id])
  end

  def update
    @round = Round.find(params[:id])

    unless params[:round][:state]
      unless params[:round_live]
        @round.state = Round::DONE
      else
        @round.state = Round::RUNNING
      end
    end

    respond_to do |format|
      if @round.update_attributes(params[:round])
        @round.update_state
        if @round.game.playable_type == "TreePosition"
          @final = @round.game.playable.tree.tree_positions.find(:first,
                                                                 :conditions => "position = 1")
        end
        format.js   { render :action => "update" }
        format.html { redirect_to params[:referer] }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @round.errors, :status => :unprocessable_entity }
      end
    end
  end
end
