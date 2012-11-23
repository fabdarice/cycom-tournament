class Team < ActiveRecord::Base
  has_many :memberships
  has_many :users, :through => :memberships
  has_many :branches, :through => :memberships, :uniq => true

  # Avoid mass assignment
  attr_accessible :name, :tag, :website, :email, :irc, :motto, :nationality,
  :password, :password_confirmation

  # Validations
  validates_presence_of :name, :tag, :email
  validates_uniqueness_of :name, :tag
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  validates_presence_of :password, :if => :should_give_password?
  validates_presence_of :password_confirmation, :if => :should_give_password_confirmation?
  validates_confirmation_of :password
  
  # Password attribute
  attr_reader :password

  # Assign password attribute and generate random salt and SHA1 digest
  def password=(pass)
    @password = pass
    self.password_salt = [Array.new(10) { rand(256).chr }.join].pack("m").chomp
    self.password_hash = Digest::SHA1.hexdigest(pass + password_salt)
  end

  def password_is?(pass)
    password_hash == Digest::SHA1.hexdigest(pass + password_salt)
  end

  private

  def should_give_password?
    self.password_hash.nil?
  end

  def should_give_password_confirmation?
    !@password.nil?
  end
end
