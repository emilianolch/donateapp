# frozen_string_literal: true

Ransack.configure do |config|
  config.add_predicate "date_lteq",
    arel_predicate: "lteq",
    formatter: proc { |v| v.to_date },
    validator: proc { |v| v.present? },
    type: :date

  config.add_predicate "date_gteq",
    arel_predicate: "gteq",
    formatter: proc { |v| v.to_date },
    validator: proc { |v| v.present? },
    type: :date
end
