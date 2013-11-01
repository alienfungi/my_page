# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  content          :text
#  commentable_type :string(255)
#  commentable_id   :integer
#  user_id          :integer
#  created_at       :datetime
#  updated_at       :datetime
#

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
