module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Thesis Application Manager"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def default_button(current_user)
  	if current_user.incomplete_information?
      return 'Personal Information'
    end
    case Role.find(current_user.role_id).name
    when 'Student'
      if current_user.student.diploma_project
       return 'Dashboard'
      else
        return 'Diploma Projects'
      end
    when 'Profesor'
      return 'My Diploma Projects'
    end
  end

  def custom_bootstrap_flash
    flash_messages = []
    flash.each do |type, message|
      type = 'success' if type == 'notice'
      type = 'error'   if type == 'alert'
      text = "<script>toastr.#{type}('#{message}');</script>"
      flash_messages << text.html_safe if message
    end
    flash_messages.join("\n").html_safe
  end

  def nav_link(link_text, link_path)
    class_name = current_page?(link_path) ? 'active navButton' : ''

    content_tag(:li, :class => class_name) do
      link_to link_text, link_path
    end
  end
end
