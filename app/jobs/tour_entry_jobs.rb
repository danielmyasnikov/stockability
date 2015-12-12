class TourEntryJobs
  include SuckerPunch::Job

  def calculate_variance(tour_entry_id)
    ActiveRecord::Base.connection_pool.with_connection do
      te = TourEntry.find(tour_entry_id)
      te.update_column(:variance, te.quantity.to_f - te.stock_level_qty.to_f)
    end
  end
end
