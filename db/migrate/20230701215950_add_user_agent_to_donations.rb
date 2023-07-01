class AddUserAgentToDonations < ActiveRecord::Migration[7.0]
  def change
    add_column :donations, :user_agent, :string
  end
end
