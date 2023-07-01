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
    current_user.donations.create!(
      uuid: preference["external_reference"],
      user_agent: request.user_agent,
      remote_ip: request.remote_ip,
    )

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
