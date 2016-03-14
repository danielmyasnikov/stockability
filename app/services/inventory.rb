module Services
  class Inventory
    def initialize(tour_entry)
      @tour_entry  = tour_entry
    end

    def assign
      case 
      when stock_level.empty?
        puts 'stock_level is nil for tour_entry: ' + @tour_entry.id.to_s
        puts '[WARN] destroing record'
        @tour_entry.destroy
      when stock_level.size > 1
        puts 'Multiple SE for tour_entry: ' + @tour_entry.id
      else
        puts "TourEntry: #{@tour_entry.id} with SE: #{stock_level.first.id}"
        @tour_entry.stock_level_id = stock_level.first.id
      end
    end 

    def stock_level
      @stock_level ||= StockLevel.where(
        :location_code => @tour_entry.location_code,
        :bin_code      => @tour_entry.bin_code,
        :sku           => @tour_entry.sku,
        :batch_code    => @tour_entry.batch_code,
        :company_id    => @tour_entry.company_id
      )
    end

    def save
      assign
      @tour_entry.try(:save)
    end
  end
end