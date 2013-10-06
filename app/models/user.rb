require 'bcrypt'

class User < ActiveRecord::Base
  attr_accessor :new_password, :new_password_confirmation, :password

  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships
  has_many :inverse_friendships, class_name: "Friendship", foreign_key: :friend_id, dependent: :destroy
  has_many :inverse_friends, through: :inverse_frienships, source: :user

  has_many :sent_messages, class_name: "Message", foreign_key: :sender_id
  has_many :received_messages, class_name: "Message", foreign_key: :recipient_id
  has_many :activities

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  WORD_CHARS = /\A\w+\z/

  # username validations
  validates(:username,
            presence: true,
            format: { with: WORD_CHARS },
            length: 3..20)
  validates_uniqueness_of :username, case_sensitive: false

  # email validations
  validates(:email,
            presence: true,
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: true)

  # password validations
  validates_confirmation_of :new_password, :if => :password_changed?

  before_save :hash_new_password
  before_save  { |user| user.email = email.downcase }
  before_save :create_remember_token

  default_scope { where(confirmed: true).order('lower(username) ASC') }

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

  def self.find_by_identifier(identifier)
    User.where("lower(username) = ?", identifier.downcase).first ||
      User.where("lower(email) = ?", identifier.downcase).first
  end

  def self.purge_unconfirmed(num)
    User.unscoped.where(confirmed: false).where("updated_at < ?", num.days.ago).destroy_all
  end

private

  def hash_new_password
    unhashed_password = @new_password || @password
     unless unhashed_password.blank?
       self.hashed_password = BCrypt::Password.create(unhashed_password)
     end
  end

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

end
