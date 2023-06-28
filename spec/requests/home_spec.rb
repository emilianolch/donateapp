# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Home', type: :request do
  describe 'index' do
    it 'renders a successful response' do
      get root_path
      expect(response).to be_successful
    end
  end
end
