# frozen_string_literal: true

require "rails_helper"
require "mercadopago"

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

  describe "notification" do
    before do
      allow_any_instance_of(Mercadopago::SDK) # rubocop:disable RSpec/AnyInstance
        .to receive_message_chain(:payment, :get) # rubocop:disable RSpec/MessageChain
        .and_return({
          response: {
            "external_reference" => donation.uuid,
            "status" => "approved",
            "transaction_amount" => 10,
            "transaction_details" => {
              "net_received_amount" => 9.25,
            },
          },
        })

      sign_out user
    end

    let!(:donation) { create(:donation, user: user) }
    let(:params) do
      {
        type: "payment",
        data: {
          id: "123",
        },
      }
    end

    it "returns http success" do
      post notification_payments_path, params: params, as: :json
      expect(response).to have_http_status(:success)
    end

    it "updates the donation" do
      expect { post notification_payments_path, params: params, as: :json }
        .to change { donation.reload.total_paid_amount }.to(10)
        .and change { donation.reload.net_received_amount }.to(9.25)
        .and change { donation.reload.payment_status }.to("approved")
    end
  end
end
