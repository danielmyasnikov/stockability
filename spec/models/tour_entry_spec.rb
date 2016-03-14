require 'rails_helper'

RSpec.describe TourEntry, :type => :model do

  let(:tour_entry) { FactoryGirl.create(:tour_entry,
                                    :quantity => 10) }

  describe '#calculate_variance' do
    
    subject { tour_entry.calculate_variance }
    
    it 'calculates variance' do
      subject
      expect(tour_entry.variance).to eq(9)
    end
  end

  describe '#adjust_variance' do
    subject { tour_entry.adjust_variance }

    it 'adjusts variance' do
      subject
      expect(tour_entry.variance).to eq(0)
    end

    it 'calculates stock_level_qty' do
      subject
      expect(tour_entry.stock_level_qty).to eq(10)
    end

    it 'sums stock_level quantity with tour entry variance' do
      subject
      expect(tour_entry.stock_level.quantity).to eq(10)
    end

    it 'hides a processed tour_entry' do
      subject
      expect(tour_entry.visible).to eq(false)
    end
  end
end