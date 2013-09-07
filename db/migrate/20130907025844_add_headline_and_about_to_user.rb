class AddHeadlineAndAboutToUser < ActiveRecord::Migration
  def change
    add_column :users, :headline, :string
    add_column :users, :about, :text
  end
end
