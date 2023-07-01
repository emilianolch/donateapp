# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, prepend: true

  before_action :authenticate_user!

  private

  def authenticate_admin!
    redirect_to root_path, alert: t("messages.not_authorized") unless current_user&.admin?
  end
end
