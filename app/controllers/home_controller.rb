# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @donations = current_user.donations.order(created_at: :desc).committed

    respond_to do |format|
      format.html
    end
  end
end
