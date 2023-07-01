# frozen_string_literal: true

# == Schema Information
#
# Table name: donations
#
#  id                  :bigint           not null, primary key
#  net_received_amount :float            default(0.0), not null
#  payment_data        :json
#  payment_status      :integer          default("not_committed"), not null
#  remote_ip           :string
#  total_paid_amount   :float            default(0.0), not null
#  user_agent          :string
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
require "rails_helper"

RSpec.describe Donation do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "enums" do
    it { is_expected.to define_enum_for(:payment_status) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:payment_status) }
    it { is_expected.to validate_presence_of(:uuid) }
  end

  describe "payment notification" do
    let(:donation) { create(:donation) }

    it "sends a payment confirmation email" do
      expect do
        donation.update!(payment_status: :approved)
      end.to have_enqueued_mail(UserMailer, :payment_confirmation)
    end
  end
end
