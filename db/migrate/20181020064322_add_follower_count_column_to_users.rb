class AddFollowerCountColumnToUsers < ActiveRecord::Migration[5.2]
  def change
  	add_column :users, :follower_count, :integer, default: 0
  end
end
