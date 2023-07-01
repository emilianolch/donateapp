# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let(:donation) { create(:donation) }
  let(:mail) { described_class.with(donation: donation).payment_confirmation }

  describe "payment confirmation" do
    it "renders the headers" do
      expect(mail.subject).to eq("Confirmación de donación")
      expect(mail.to).to eq([donation.user.email])
      expect(mail.from).to eq(["notifications@donate.app"])
    end

    it "delivers the email" do
      expect(mail.deliver_now).to be_truthy
    end
  end
end
