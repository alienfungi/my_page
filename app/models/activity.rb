# == Schema Information
#
# Table name: activities
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  action         :string(255)
#  trackable_id   :integer
#  trackable_type :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  old            :boolean          default(FALSE)
#

class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :trackable, polymorphic: true
  default_scope { order('created_at DESC') }

  def self.purge_old(num = 30)
    Activity.where("created_at < ?", num.days.ago).destroy_all
  end
end
