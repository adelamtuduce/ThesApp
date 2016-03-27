# encoding: UTF-8
# @module DeviseHelper
module DeviseHelper
  def devise_error_messages!
    return '' if resource.errors.empty?

    html = '<div class="error_messages alert alert-danger"><strong>Please correct the following errors:</strong><ul>'

    resource.errors.full_messages.each do |msg|
      html << "<li>#{msg}</li>"
    end

    html << '</ul></div>'

    html.html_safe
  end
end