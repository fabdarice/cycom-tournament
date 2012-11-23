class Subscription < ActiveRecord::Base
  belongs_to :tournament
  belongs_to :user, :foreign_key => :participant_id
  belongs_to :membership, :foreign_key => :participant_id

  validates_presence_of :tournament_id, :participant_id
end
