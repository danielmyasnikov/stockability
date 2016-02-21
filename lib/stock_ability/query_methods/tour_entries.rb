module StockAbility
  module QueryMethods
    module TourEntries

      def adjust
        each do |entry|
          slevel = StockLevel.find_by_entry(entry)
          slevel.update_attribute(:quantity, slevel.quantity + entry.variance)
          hide_tour_entries_by_keys(entry)
        end
      end

      def reject
        each do |entry|
          hide_tour_entries_by_keys(entry)
        end
      end

      def hide_tour_entries_by_keys(entry)
        TourEntry.where(entry.composite_key_attributes).
          update_all(:visible => false)
      end

      def group_by_tour
        joins(:tour).select(select_fields).group(group_fields)
      end

      def group_fields
        "
          tours.name,
          tours.id,
          location_code,
          bin_code,
          sku,
          tours.company_id,
          batch_code
        "
      end

      def select_fields
        "
          tours.company_id,
          tours.name as tour_name,
          tours.id   as tour_id,
          tour_entries.location_code,
          tour_entries.bin_code,
          tour_entries.sku,
          tour_entries.batch_code,
          SUM(tour_entries.quantity) as sum_quantity,
          MAX(tour_entries.stock_level_qty) as stock_level_qty
        "
      end

      def composite_key
        StockLevel.composite_key.map(&:to_s)
      end
    end
  end
end

TourEntry::ActiveRecord_Relation.include(StockAbility::QueryMethods::TourEntries)