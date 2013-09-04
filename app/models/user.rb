require 'bcrypt'

class User < ActiveRecord::Base
  attr_accessor :new_password, :new_password_confirmation

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validate :email, presence: true,
    format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false }
  validates_confirmation_of :new_password, :if => :password_changed?

  before_save :hash_new_password, :if => :password_changed?
  before_save  { |user| user.email = email.downcase }
  before_save :create_remember_token

  def password_changed?
    !@new_password.blank?
  end

  def self.authenticate(email, password)
    if user = find_by_email(email)
      if BCrypt::Password.new(user.hashed_password).is_password? password
        return user
      end
    end

    return nil
  end

private

  def hash_new_password
    self.hashed_password = BCrypt::Password.create(@new_password)
  end

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end
