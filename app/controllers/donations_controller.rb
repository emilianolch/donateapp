# frozen_string_literal: true

class DonationsController < ApplicationController
  include RansackMemory::Concern

  before_action :authenticate_admin!
  before_action :set_donation, only: [:show, :update, :destroy]
  before_action :save_and_load_filters, only: [:index]

  def index
    @q = Donation.ransack(params[:q])
    @donations = @q.result.preload(:user)

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
    respond_to do |format|
      format.html do
        if @donation.update(donation_params)
          redirect_to @donation, notice: t("messages.donation_updated")
        else
          render :show, status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    respond_to do |format|
      format.html do
        if @donation.destroy
          redirect_to donations_url, notice: t("messages.donation_destroyed")
        else
          head :unprocessable_entity
        end
      end
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
