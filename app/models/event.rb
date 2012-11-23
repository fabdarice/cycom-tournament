class Event < ActiveRecord::Base
  has_many :tournaments

  attr_accessible :name, :address, :description, :starts_at, :ends_at

  validates_presence_of :name, :starts_at, :ends_at
end
