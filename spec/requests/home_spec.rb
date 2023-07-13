# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Home" do
  let(:user) { create(:user) }

  before { sign_in user }

  describe "index" do
    before { create_list(:donation, 3, user: user, payment_status: :approved) }

    it "renders a successful response" do
      get root_path
      expect(response).to be_successful
    end
  end
end
