# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Donations", type: :request do
  let(:donator) { create(:user) }
  let(:donation) { create(:donation, user: donator) }

  before { sign_in user }

  context "when user is not admin" do
    let(:user) { create(:user) }

    describe "index" do
      it "redirects to root path" do
        get donations_path
        expect(response).to redirect_to(root_path)
      end
    end

    describe "show" do
      it "redirects to root path" do
        get donation_path(donation)
        expect(response).to redirect_to(root_path)
      end
    end

    describe "update" do
      it "redirects to root path" do
        patch donation_path(donation)
        expect(response).to redirect_to(root_path)
      end
    end

    describe "destroy" do
      it "redirects to root path" do
        delete donation_path(donation)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  context "when user is admin" do
    let(:user) { create(:user, admin: true) }

    describe "index" do
      before { create_list(:donation, 3, user: donator) }

      it "renders a successful response" do
        get donations_path
        expect(response).to be_successful
      end
    end

    describe "show" do
      it "renders a successful response" do
        get donation_path(donation)
        expect(response).to be_successful
      end
    end

    describe "update" do
      context "with valid params" do
        let(:new_attributes) { { payment_status: :approved } }

        it "updates the requested donation" do
          patch donation_path(donation), params: { donation: new_attributes }
          donation.reload
          expect(donation.payment_status).to eq("approved")
        end

        it "redirects to show path" do
          patch donation_path(donation), params: { donation: new_attributes }
          donation.reload
          expect(response).to redirect_to(donation_path(donation))
        end
      end

      context "with invalid params" do
        let(:new_attributes) { { payment_status: nil } }

        it "renders an unprocessable entity response" do
          patch donation_path(donation), params: { donation: new_attributes }
          expect(response).to be_unprocessable
        end
      end
    end

    describe "destroy" do
      let!(:donation) { create(:donation, user: donator) }

      it "destroys the requested donation" do
        expect do
          delete donation_path(donation)
        end.to change(Donation, :count).by(-1)
      end

      it "redirects to the donations list" do
        delete donation_path(donation)
        expect(response).to redirect_to(donations_path)
      end
    end
  end
end
