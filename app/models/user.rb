class User < ActiveRecord::Base
    has_many :cookies, :class_name => "UserCookie"
    has_many :branches, :through => :memberships
    has_many :teams, :through => :memberships
    #has_many :articles
    #has_many :orders
    has_many :subscriptions, :foreign_key => "participant_id"
    has_many :tournaments, :through => :subscriptions
    
    # Avoid mass assignment
    attr_accessible :first_name, :last_name, :nickname, :email, :password,
    :password_confirmation, :phone, :address, :city, :zip_code, :country,
    :sex, :birthdate

    # Validations
    validates_presence_of :first_name, :last_name, :nickname, :email, :birthdate
    validates_uniqueness_of :nickname, :email
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

    def admin?
      admin
    end

    # Password is mandatory only at account creation
    def should_give_password?
      self.password_hash.nil?
    end

    # Password confirmation is madatory only at account creation 
    # or when password is specified
    def should_give_password_confirmation?
      should_give_password? or !@password.nil?
    end
    
    def self.available_for_tournament(tournament_id)  
      result = []
      users = all

      for user in users
        result << user unless user.tournaments.exists?(tournament_id)
      end

      result
    end
end
