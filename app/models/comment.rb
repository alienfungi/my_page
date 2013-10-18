class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  has_many :activities, as: :trackable

  validates_presence_of :content

  before_save :correct_user?

  default_scope { order('created_at ASC') }

private

  def correct_user?
    (user == commentable.user) || commentable.user.mutual_friends.exists?(user.id)
  end
end
