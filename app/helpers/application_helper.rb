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
end
