# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Payments", type: :request do
  let(:user) { create(:user) }

  before { sign_in user }

  describe "create" do
    it "redirects to MercadoPago" do
      post payments_path
      expect(response).to redirect_to(/mercadopago/)
    end

    it "creates a donation" do
      expect { post payments_path }.to change(Donation, :count).by(1)
    end
  end

  describe "success" do
    it "redirects to root_path" do
      get success_payments_path
      expect(response).to redirect_to(root_path)
    end

    it "sets a flash notice" do
      get success_payments_path
      expect(flash[:notice]).to eq(I18n.t("payments.success"))
    end
  end

  describe "failure" do
    it "redirects to root_path" do
      get failure_payments_path
      expect(response).to redirect_to(root_path)
    end

    it "sets a flash alert" do
      get failure_payments_path
      expect(flash[:alert]).to eq(I18n.t("payments.failure"))
    end
  end

  describe "pending" do
    it "redirects to root_path" do
      get pending_payments_path
      expect(response).to redirect_to(root_path)
    end

    it "sets a flash alert" do
      get pending_payments_path
      expect(flash[:alert]).to eq(I18n.t("payments.pending"))
    end
  end
end
