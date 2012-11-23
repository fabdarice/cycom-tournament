class Tournament < ActiveRecord::Base
  belongs_to :event
  has_one :tree
  has_many :rankings
  has_many :subscriptions
  has_many :users, :through => :subscriptions
  has_many :memberships, :through => :subscriptions

  # Avoid mass assignment
  attr_accessible :name, :event_id, :branch_id, :name, :max_participants, :participants_type,
  :starts_at, :ends_at, :state

  validates_presence_of :name, :branch_id, :event_id, :max_participants, :starts_at,
  :ends_at, :participants_type, :state

  PARTICIPANT_TYPE_SINGLE = "individual"
  PARTICIPANT_TYPE_TEAM = "team"
  PARTICIPANTS_TYPE = [ PARTICIPANT_TYPE_SINGLE, PARTICIPANT_TYPE_TEAM ]
  
  # state values
  WAITING = I18n.translate("state.waiting")
  RUNNING = I18n.translate("state.running")
  DONE = I18n.translate("state.done")
  DRAW = I18n.translate("state.draw")
  WIN_FIRST = I18n.translate("state.win_first")
  WIN_SECOND = I18n.translate("state.win_second")
  STATES = [ WAITING, RUNNING, DONE, DRAW, WIN_FIRST, WIN_SECOND ]

  def is_individual?
    participants_type == PARTICIPANT_TYPE_SINGLE
  end

  def is_in_team?
    participants_type == PARTICIPANT_TYPE_TEAM
  end

  # Tell if the visitor is susbcribed to this tournament
  def has_subscriber?(user_id)
    # In the case of an Indivual tournament
    if is_individual?
      users.exists?(user_id)
    else
      # If we are in a team kind of tournament
      memberships.exists?(:user_id => user_id)
    end
  end
  
  # Give a hash of subscribed users per team
  def users_by_team
    result = {}
    
    memberships.each do |membership|
      result[membership.team] ||= []
      result[membership.team] << membership.user.nickname
    end
    
    result
  end

  def unsubscribe(user_id)
    if is_individual?
      user = users.find(user_id)
      return false unless user
      participant_id = user.id
    else
      membership = memberships.where(:user_id => user_id).first
      return false unless membership
      participant_id = membership.id
    end
  
    Subscription.delete_all([ "tournament_id = ? AND participant_id = ?",
                            id, participant_id ])
    true
  end

  # Give the number of the added round
  def next_round
   rankings.size + 1
  end

  def fill_ranking(round)
    if round == 1
      participants = []
      
      if is_individual?
        subscriptions.each do |subscription|
          participants << subscription.participant_id
        end
      else
        memberships.each do |membership|
          participants << membership.team_id unless participants.include?(membership.team_id)
        end
      end
    end

    ranking = rankings.find_by_round(round)
    participants.each do |participant|
      ranking.add_participant(participant)
    end
  end

  def fill_tree
    participants = []
    if rankings.size > 0
      participants = rankings.find_by_round(rankings.size).qualified_participants
    else
      if is_individual?
        subscriptions.each do |subscription|
          participants << subscription.participant_id
        end
      else
        memberships.each do |membership|
          participants << membership.team_id unless participants.include?(membership.team_id)
        end
      end
    end

    tree.set_participants(participants)
  end
end
