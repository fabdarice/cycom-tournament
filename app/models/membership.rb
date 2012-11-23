class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :team
  belongs_to :branch

  # Validations
  validates_presence_of :user_id, :team_id, :branch_id

  # Give a hash of branch, with a table of memberships
  # For example:
  # result["Staff"] = [ { :user => Hatake, :id => X } ], { :user => admin, :id => X } ]
  # result["Counter-Strike 1.6] = [ { :user => Hatake, :id => X } ]
  #
  # Used in the show team page
  def self.user_branches(team_id)
    memberships = where(:team_id => team_id).includes(:user, :branch)
    result = {}
    memberships.each do |m|
      result[m.branch] ||= []
      result[m.branch] << m
    end

    result
  end

  # Give a hash of branch, with a table of memberships
  # For example:
  # result["Staff"] = [ { :team => Cycom, :id => X }, { :team => HatakeTeam, :id => X } ]
  # result["Counter-Strike 1.6] = [ { :team => Cycom, :id => X } ]
  #
  # Used in the show user page
  def self.team_branches(user_id)
    #memberships = Membership.find(:all,
    #                              :conditions => [ "user_id = ?", user_id ],
    #                              :include => [:team, :branch])
    memberships = where(:user_id => user_id).includes(:team, :branch)
    
    result = {}
    memberships.each do |m|
      result[m.branch] ||= []
      result[m.branch] << m
    end

    result
  end

  # Return all the memberships of the user designed by user_id that have
  # the same branch than the tournament
  def self.available_for_tournament(tournament, user_id)
    #Membership.find(:all, :conditions => [ "user_id = ? AND branch_id = ?",
    #                                     user_id, tournament.branch_id])
    where("user_id = ? AND branch_id = ?", user_id, tournament.branch_id)
  end


  def desc
    "#{team.name} (#{branch.name})"
  end
end
