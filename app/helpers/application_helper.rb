# frozen_string_literal: true

module ApplicationHelper
  def flash_class(flash_type)
    case flash_type
    when "alert"
      "alert-danger"
    when "notice"
      "alert-success"
    else
      "alert-#{flash_type}"
    end
  end
end
