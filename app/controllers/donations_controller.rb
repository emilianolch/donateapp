# frozen_string_literal: true

class DonationsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_donation, only: [:show, :update]

  def index
    @donations = Donation.all.preload(:user)

    respond_to do |format|
      format.html
    end
  end

  def show
    respond_to do |format|
      format.html
    end
  end

  def update
    if @donation.update(donation_params)
      redirect_to @donation, notice: t("messages.donation_updated")
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def set_donation
    @donation = Donation.find(params[:id])
  end

  def donation_params
    params.require(:donation).permit(:payment_status)
  end
end
