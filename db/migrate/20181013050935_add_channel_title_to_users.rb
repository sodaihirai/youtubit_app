class AddChannelTitleToUsers < ActiveRecord::Migration[5.2]
  def change
  	add_column :microposts, :channel_title, :string
  end
end
