class StockLevelsProcessor
  attr_reader :stock_levels, :entries
  def initialize(stock_levels, tour)
    @stock_levels = StockLevel.where(id: stock_levels)
    @tour = Tour.find(tour) rescue nil
  end

  def process
    stock_levels.each do |stock_level|
      @tour_entry = TourEntry.new do |te|
        te.stock_level_id   = stock_level.id
        te.bin_code         = stock_level.bin_code
        te.sku              = stock_level.sku
        te.batch_code       = stock_level.batch_code
        te.stock_level_qty  = stock_level.quantity
        te.company_id       = stock_level.company_id
        te.location_code    = stock_level.location_code
        te.active           = true
      end

      if @tour_entry.save
        entries << @tour_entry
        stock_level.tour_entries << @tour_entry
      else
        errors << @tour_entry.errors
      end
    end
    unless @tour.nil?
      # TODO: sort out relationship between tour entries and tours
      # if has_many belongs to this will overrided tour entries for the other tour
      @tour.entries << entries
    end
  end

  def errors
    @errors ||= []
  end

  def tour_entry
    @tour_entry ||= TourEntry.new
  end

  def entries
    @entries ||= []
  end
end
