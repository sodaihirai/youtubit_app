class ChangeObhectIdNameOfActions < ActiveRecord::Migration[5.2]
  def change
  	rename_column :actions, :object_id, :type_id
  end
end
