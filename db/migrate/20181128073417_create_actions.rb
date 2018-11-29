class CreateActions < ActiveRecord::Migration[5.2]
  def change
    create_table :actions do |t|
    	t.integer :action_user_id
    	t.text    :content
      t.timestamps
    end
  end
end
