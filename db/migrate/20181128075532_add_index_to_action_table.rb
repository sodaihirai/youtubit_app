class AddIndexToActionTable < ActiveRecord::Migration[5.2]
  def change
  	add_index :actions, :action_user_id
  end
end
