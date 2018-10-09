class ChangeNameRememberMeToRememberDigest < ActiveRecord::Migration[5.2]
  def change
  	rename_column :users, :remember_me, :remember_digest
  end
end
