module ApplicationHelper
  def flash_message
    flash.map do |type, messages|
      message = safe_join(Array(messages), '<br>')
      message = content_tag(:div, message, :class => 'alert-wrapper')
      content_tag(:div, message, :class => "alert alert-#{flash_class(type)} alert-flash")
    end.join.html_safe
  end

  def flash_class(type)
    case type
    when 'notice' then 'success'
    when 'alert'  then 'danger'
    else type
    end
  end

  def interpret_status(status)
    Services::ProductsBarcodesImporter::STATUS[status]
  end

  def interpret_message(errors)
    return 'No Errors' unless errors.present?
    errors.map(&:message).join(', ')
  end
end
