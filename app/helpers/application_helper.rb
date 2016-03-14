module ApplicationHelper

  def datetime
    "%H:%M %d-%m-%Y"
  end
  
  def edit_admin_nav_active?(menu_name)
    if action_name == menu_name
      'active'
    end
  end

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

  def collapse!
    if cookies['sa.collapsed'].present?
      'mini-navbar'
    end
  end

  def home_path_for(resource)
    if resource.super_admin?
      users_companies_path
    else
      users_products_path
    end
  end

  def interpret_status(status)
    ProductsBarcodesImporter::STATUS[status]
  end

  def interpret_message(errors)
    return 'No Errors' unless errors.present?
    errors.map(&:message).join(', ')
  end

  def in_style_menu title, path, options = {}
    link_options = { :href => path }.merge(options)
    icon         = options[:icon] || 'fa-th-large'
    nav_label    = options[:nav_label] || 'nav-label'
    link_options.merge!(tooltip(title)) if options[:tooltip]

    content_tag :li, :class => active(path) do
      content = content_tag :a, link_options do
        concat(content_tag :i, nil, :class => ['fa', icon])
        concat(content_tag(:span, title, :class => nav_label))
      end
    end
  end

  def tooltip title
    { :data => { :toggle => 'tooltip', :placement => 'right', :title => title } }
  end

  def active(path)
    'active' if request.fullpath.match(path)
  end
end
