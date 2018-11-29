class AddSomeColumnsToActionTable < ActiveRecord::Migration[5.2]
  def change
  	add_column :actions, :object_id, :integer
  	add_column :actions, :action_type, :string
  end
end
