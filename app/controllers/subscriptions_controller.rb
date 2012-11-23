class SubscriptionsController < ApplicationController
  before_filter "logged_in?"

  # Subscribe to a given tournament
  def create
    tournament = Tournament.find(params[:tournament_id])
    s = Subscription.new
    s.tournament_id = tournament.id
    if tournament.is_individual?
      s.participant_id = params[:participant_id] || session[:user_id]
      
      flash[:valid] = I18n.t('subscription.ok') if s.save
    else
      if params[:membership_id]
        s.participant_id = params[:membership_id]

        flash[:valid] = I18n.t('subscription.ok') if s.save
      end
    end
    redirect_to :back
  end

  # Unsuscribe
  def destroy
    tournament = Tournament.find(params[:tournament_id])
    if tournament.unsubscribe(session[:user_id])
      flash[:valid] = I18n.t('subscription.destroy')
    end

    redirect_to :back
  end
end
