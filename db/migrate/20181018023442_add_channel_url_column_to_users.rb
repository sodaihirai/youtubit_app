class AddChannelUrlColumnToUsers < ActiveRecord::Migration[5.2]
  def change
  	add_column :microposts, :channel_url, :string
  end
end
