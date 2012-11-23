class Post < ActiveRecord::Base
  belongs_to :author, :class_name => "User"
  
  # Avoid mass assignment
  attr_accessible :title, :content, :date

  # Validations
  validates_presence_of :title, :content, :author_id, :date
end
