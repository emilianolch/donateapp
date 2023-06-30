# frozen_string_literal: true

require "mercadopago"

class PaymentsController < ApplicationController
  skip_before_action :authenticate_user!, only: :notification
  skip_forgery_protection only: :notification

  def create
    sdk = Mercadopago::SDK.new(ENV["MP_ACCESS_TOKEN"])
    sdk.request_options.integrator_id = ENV["MP_INTEGRATOR_ID"]

    preference_data = {
      items: [
        {
          title: t("payments.item_title"),
          quantity: 1,
          unit_price: 10,
        },
      ],
      back_urls: {
        success: success_payments_url,
        failure: failure_payments_url,
        pending: notification_payments_url,
      },
      auto_return: "approved",
      notification_url: notification_payments_url,
    }

    preference = sdk.preference.create(preference_data)[:response]
    redirect_to preference["init_point"], allow_other_host: true
  end

  def success
    respond_to do |format|
      format.html { redirect_to root_path, notice: t("payments.success") }
    end
  end

  def notification
    respond_to do |format|
      format.json { head :no_content }
    end
  end
end
