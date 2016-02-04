desc 'Update Stock (one off task)'
task :update_stock_level_id_for_tour_entries => :environment do
  TourEntry.all.each do |te|
    company_id = te.tour.company_id rescue nil
    if company_id.nil?
      puts "Destroying TourEntry without company: #{te.id}"
      te.destroy
      next
    else
      inventory = StockAbility::Inventory.new(te)
      inventory.save
    end
  end
end