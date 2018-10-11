class CreateMicroposts < ActiveRecord::Migration[5.2]
  def change
    create_table :microposts do |t|
      t.text :content
      t.string :video_title
      t.string :video_url
      t.string :video_thumbnail
      t.string :video_type
      t.references :user, foreign_key: true


      t.timestamps
    end
    add_index :microposts, [:user_id, :created_at]
  end
end
