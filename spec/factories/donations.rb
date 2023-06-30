FactoryBot.define do
  factory :donation do
    user { nil }
    uuid { "MyString" }
    total_paid_amount { 1.5 }
    net_received_amount { 1.5 }
    data { "" }
  end
end
