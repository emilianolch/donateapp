# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def payment_confirmation
    @donation = params[:donation]
    @user = @donation.user
    mail(to: @user.email, subject: t("user_mailer.payment_confirmation.subject"))
  end
end
