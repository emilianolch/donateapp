# frozen_string_literal: true

class CreateDonations < ActiveRecord::Migration[7.0]
  def change
    create_table :donations do |t|
      t.references :user, null: false, foreign_key: true
      t.string :uuid
      t.float :total_paid_amount, null: false, default: 0.0
      t.float :net_received_amount, null: false, default: 0.0
      t.integer :payment_status, null: false, default: 0
      t.json :payment_data

      t.timestamps
    end
    add_index :donations, :uuid
  end
end
