# frozen_string_literal: true

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
end
