# frozen_string_literal: true

# == Schema Information
#
# Table name: donations
#
#  id                  :bigint           not null, primary key
#  net_received_amount :float            default(0.0), not null
#  payment_data        :json
#  payment_status      :integer          default("not_committed"), not null
#  total_paid_amount   :float            default(0.0), not null
#  uuid                :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  user_id             :bigint           not null
#
# Indexes
#
#  index_donations_on_user_id  (user_id)
#  index_donations_on_uuid     (uuid)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Donation < ApplicationRecord
  belongs_to :user

  enum payment_status: {
    not_committed: 0,
    pending: 1,
    approved: 2,
    authorized: 3,
    in_process: 4,
    in_mediation: 5,
    rejected: 6,
    cancelled: 7,
    refunded: 8,
    charged_back: 9,
  }

  validates :uuid, presence: true

  scope :committed, -> { where.not(payment_status: :not_committed) }
end
