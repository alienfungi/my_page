class AddRememberTokenToUsers < ActiveRecord::Migration
  def change
    change_table(:users) do |t|
      t.column :remember_token, :string
      t.timestamps
    end
  end
end
