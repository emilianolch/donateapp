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
FactoryBot.define do
  factory :donation do
    user
    uuid { SecureRandom.uuid }
    user_agent { Faker::Internet.user_agent }
    remote_ip { Faker::Internet.ip_v4_address }
  end
end
