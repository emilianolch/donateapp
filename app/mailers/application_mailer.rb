# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "notifications@donate.app"
  layout "mailer"
end
