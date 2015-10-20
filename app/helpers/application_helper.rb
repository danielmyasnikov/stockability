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

  def in_style_comfy_meny title, path
    content_tag :li, :class => active(path) do
      content = content_tag :a, :href => path do
        concat(content_tag :i, nil, :class => ['fa', 'fa-th-large'])
        concat(content_tag(:span, title, :class => 'nav-label'))
      end
    end
  end

  def active(path)
    'active' if request.fullpath == path
  end
end
