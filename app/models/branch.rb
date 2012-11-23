class Branch < ActiveRecord::Base
  validates_presence_of :name, :abbreviation
  validates_uniqueness_of :name, :abbreviation
end
