class AddRemoteIpToDonations < ActiveRecord::Migration[7.0]
  def change
    add_column :donations, :remote_ip, :string
  end
end
