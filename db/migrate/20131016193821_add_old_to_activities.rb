class AddOldToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :old, :boolean, default: false
  end
end
