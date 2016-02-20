module TourEntriesHelper
  
  def scoped_params(scoped_entry)
    {
      location_code: scoped_entry.location_code,
      bin_code:      scoped_entry.bin_code,
      sku:           scoped_entry.sku,
      batch_code:    scoped_entry.batch_code,
      tour_id:       scoped_entry.tour_id
    }
  end

  def colour_picker(sum)
    return if sum.blank? || sum == 0
    if sum < 0
      return 'reddy'
    else
      return 'greeny'
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
