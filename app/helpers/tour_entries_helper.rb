module TourEntriesHelper
  def colour_picker(sum)
    return if sum.blank? || sum == 0
    if sum < 0
      return '#FFDBEE'
    else
      return '#DEFAD4'
    end
  end

  def toggle_active
    if displays_only_variance?
      'btn-default'
    else
      'btn-success'
    end
  end

  def variance_text
    if displays_only_variance?
      'Show All'
    else
      'Show Only Variance'
    end
  end

  def displays_only_variance?
    params[:only_variance].to_s == 'true'
  end
end
