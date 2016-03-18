require 'rails_helper'

RSpec.describe TourEntry, :type => :model do

  let(:user) { FactoryGirl.create(:user, :company_admin) }

  let(:tour) { FactoryGirl.create(:tour) }

  let!(:tour_entry) { FactoryGirl.create(:tour_entry, :tour_id => tour.id,
                                                     :location_code => 'LOC0X0',
                                                     :bin_code => 'BIN0X0',
                                                     :sku => 'SKU0X0',
                                                     :barcode => 'BAR0X0',
                                                     :batch_code => 'BAR0X0',
                                                     :company_id => user.company_id,
                                                     :stock_level_qty => 1,
                                                     :quantity => 10) }

  describe '#variance' do
    it 'rocks' do
      grouped_el = TourEntry.all.group_by_tour
      grouped_el.each do |el|
        expect(el.variance).to eq(9)
      end
    end
  end
end