class AddRememberDigestToUsers < ActiveRecord::Migration[5.2]
  def change
  	add_column :users, :remember_me, :string
  end
end
