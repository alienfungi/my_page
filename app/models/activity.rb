class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :trackable, polymorphic: true
  default_scope { order('created_at DESC') }

  def self.purge_old(num = 30)
    Activity.where("created_at < ?", num.days.ago).destroy_all
  end
end
