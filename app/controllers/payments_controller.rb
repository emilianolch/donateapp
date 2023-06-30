# frozen_string_literal: true

require "mercadopago"

class PaymentsController < ApplicationController
  before_action :set_sdk, only: [:create, :notification]

  skip_before_action :authenticate_user!, only: :notification
  skip_forgery_protection only: :notification

  def create
    preference_data = {
      payer: {
        email: current_user.email,
      },
      items: [
        {
          title: t("payments.item_title"),
          quantity: 1,
          unit_price: 10,

        },
      ],
      payment_methods: {
        installments: 1,
      },
      back_urls: {
        success: success_payments_url,
        failure: failure_payments_url,
        pending: pending_payments_url,
      },
      auto_return: "approved",
      notification_url: notification_payments_url,
      external_reference: SecureRandom.uuid,
    }

    preference = @sdk.preference.create(preference_data)[:response]
    current_user.donations.create!(uuid: preference["external_reference"])

    redirect_to preference["init_point"], allow_other_host: true
  end

  # Redirects after payment
  def success
    respond_to do |format|
      format.html { redirect_to root_path, notice: t("payments.success") }
    end
  end

  def failure
    respond_to do |format|
      format.html { redirect_to root_path, alert: t("payments.failure") }
    end
  end

  def pending
    respond_to do |format|
      format.html { redirect_to root_path, alert: t("payments.pending") }
    end
  end

  # Webhook
  def notification
    respond_to do |format|
      format.json do
        if params[:type] == "payment"
          process_payment
        end
        head :ok
      end
    end
  end

  private

  def set_sdk
    @sdk = Mercadopago::SDK.new(ENV["MP_ACCESS_TOKEN"])
    @sdk.request_options.integrator_id = ENV["MP_INTEGRATOR_ID"]
  end

  def process_payment
    payment = @sdk.payment.get(params[:data][:id])[:response]
    donation = Donation.find_by(uuid: payment["external_reference"])

    return if donation.nil?

    donation.update!(
      total_paid_amount: payment["transaction_amount"],
      net_received_amount: payment["transaction_details"]["net_received_amount"],
      payment_status: payment["status"],
      payment_data: payment,
    )
  end
end

# {
#   status: 200,
#   response: {
#     "accounts_info" => nil,
#     "acquirer_reconciliation" => [],
#     "additional_info" =>
#      {
#        "authentication_code" => nil,
#        "available_balance" => nil,
#        "ip_address" => "191.82.199.69",
#        "items" => [{
#          "category_id" => nil,
#          "description" => nil,
#          "id" => nil,
#          "picture_url" => nil,
#          "quantity" => "1",
#          "title" => "Donación",
#          "unit_price" => "10",
#        }],
#        "nsu_processadora" => nil,
#      },
#     "authorization_code" => nil,
#     "binary_mode" => false,
#     "brand_id" => nil,
#     "build_version" => "3.5.0-rc-2",
#     "call_for_authorize_id" => nil,
#     "captured" => true,
#     "card" =>
#      {
#        "cardholder" => { "identification" => { "number" => "12345678", "type" => "DNI" }, "name" => "APRO" },
#        "date_created" => "2023-06-30T17:51:39.000-04:00",
#        "date_last_updated" => "2023-06-30T17:51:39.000-04:00",
#        "expiration_month" => 11,
#        "expiration_year" => 2025,
#        "first_six_digits" => "503175",
#        "id" => nil,
#        "last_four_digits" => "0604",
#      },
#     "charges_details" => [],
#     "collector_id" => 205003040,
#     "corporation_id" => nil,
#     "counter_currency" => nil,
#     "coupon_amount" => 0,
#     "currency_id" => "ARS",
#     "date_approved" => "2023-06-30T17:51:39.370-04:00",
#     "date_created" => "2023-06-30T17:51:39.215-04:00",
#     "date_last_updated" => "2023-06-30T17:51:39.370-04:00",
#     "date_of_expiration" => nil,
#     "deduction_schema" => nil,
#     "description" => "Donación",
#     "differential_pricing_id" => nil,
#     "external_reference" => nil,
#     "fee_details" => [{ "amount" => 0.41, "fee_payer" => "collector", "type" => "mercadopago_fee" }],
#     "financing_group" => nil,
#     "id" => 1316189787,
#     "installments" => 1,
#     "integrator_id" => "dev_24c65fb163bf11ea96500242ac130004",
#     "issuer_id" => "3",
#     "live_mode" => false,
#     "marketplace_owner" => nil,
#     "merchant_account_id" => nil,
#     "merchant_number" => nil,
#     "metadata" => {},
#     "money_release_date" => "2023-07-18T17:51:39.370-04:00",
#     "money_release_schema" => nil,
#     "money_release_status" => nil,
#     "notification_url" => "https://faf7-191-82-199-69.ngrok-free.app/payments/notification",
#     "operation_type" => "regular_payment",
#     "order" => { "id" => "10139234037", "type" => "mercadopago" },
#     "payer" =>
#      {
#        "first_name" => nil,
#        "last_name" => nil,
#        "email" => "test_user_80507629@testuser.com",
#        "identification" => { "number" => "32659430", "type" => "DNI" },
#        "phone" => { "area_code" => nil, "number" => nil, "extension" => nil },
#        "type" => nil,
#        "entity_type" => nil,
#        "id" => "1153552510",
#      },
#     "payment_method" => { "id" => "master", "issuer_id" => "3", "type" => "credit_card" },
#     "payment_method_id" => "master",
#     "payment_type_id" => "credit_card",
#     "platform_id" => nil,
#     "point_of_interaction" =>
#      {
#        "business_info" => { "sub_unit" => "checkout_pro", "unit" => "online_payments" },
#        "transaction_data" => { "e2e_id" => nil },
#        "type" => "CHECKOUT",
#      },
#     "pos_id" => nil,
#     "processing_mode" => "aggregator",
#     "refunds" => [],
#     "shipping_amount" => 0,
#     "sponsor_id" => nil,
#     "statement_descriptor" => "EMI",
#     "status" => "approved",
#     "status_detail" => "accredited",
#     "store_id" => nil,
#     "tags" => nil,
#     "taxes_amount" => 0,
#     "transaction_amount" => 10,
#     "transaction_amount_refunded" => 0,
#     "transaction_details" =>
#      {
#        "acquirer_reference" => nil,
#        "external_resource_url" => nil,
#        "financial_institution" => nil,
#        "installment_amount" => 10,
#        "net_received_amount" => 9.59,
#        "overpaid_amount" => 0,
#        "payable_deferral_period" => nil,
#        "payment_method_reference_id" => nil,
#        "total_paid_amount" => 10,
#      },
#   },
# }
