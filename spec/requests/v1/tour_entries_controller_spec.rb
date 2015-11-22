require 'rails_helper'

# candite for refactor
RSpec.describe 'TourEntries API', type: :request do
  let(:my_tour_entries)  { FactoryGirl.create_list(:tour_entry, 3, :company_id => @client.company_id) }
  # !other company id should not be harcoded
  let(:other_tour_entry) { FactoryGirl.create(:tour_entry, :company_id => 1) }
  let!(location) { FactoryGirl.create(:location, code: "ABC123") }

  let(:tour_entry_params) {
    {
      tour_entry:  {
        tour_id: 1,
        sku: 'TEST555',
        batch_code: 'HELLOWORLD',
        quantity: 1,
        location_code: 'ABC123',
        bin_code: '100',
        barcode: 'BAR111',
        active: true
      }
    }
  }

  before :all do; TOURENTRIESAPI = '/api/v1/tour_entries'; end

  before :each do
    @client       = FactoryGirl.create(:user, :company_admin)
    @auth_details = { auth: { token: @client.token } }
  end

  context 'when unauthorized access' do
    it 'responds with forbidden access 403' do
      get    TOURENTRIESAPI;         expect(response.status).to eq(403)
      get    TOURENTRIESAPI + '/1';  expect(response.status).to eq(403)
      post   TOURENTRIESAPI;         expect(response.status).to eq(403)
      put    TOURENTRIESAPI + '/1';  expect(response.status).to eq(403)
      delete TOURENTRIESAPI + '/1';  expect(response.status).to eq(403)
    end
  end

  describe '.index' do
    subject { get TOURENTRIESAPI, @auth_details }

    it 'display company records' do
      other_tour_entry
      my_tour_entries
      subject

      json_ids = parsed_json.map { |x| x['id'] }
      prod_ids = my_tour_entries.map(&:id)

      expect(json_ids).to eq(prod_ids)
    end

    it 'does not respond with other company records' do
      other_tour_entry
      my_tour_entries
      subject

      includes = parsed_json.map { |x| x['id'] }.include? other_tour_entry.id
      expect(includes).to be(false)
    end
  end

  describe '.show' do
    it 'display company records' do
      id = my_tour_entries.first.id
      get TOURENTRIESAPI + '/' + id.to_s, @auth_details
      expect(json['id']).to eq(id)
    end

    it 'does not respond with other company records' do
      id = other_tour_entry.id
      get TOURENTRIESAPI + '/' + id.to_s, @auth_details
      expect(response.status).to eq(403)
    end
  end

  describe '.create' do
    context 'when record invalid' do
      it 'returns unprocessed entity' do
        TourEntry.stub(:create!).and_raise(ActiveRecord::RecordInvalid.new(TourEntry.new))
        post TOURENTRIESAPI, tour_entry_params.merge(@auth_details)
        expect(response.status).to eq(422)
        expect(json['sku']).not_to eq('TEST555')
      end
    end

    it 'creates a record for the company' do
      post TOURENTRIESAPI, tour_entry_params.merge(@auth_details)
      expect(response.status).to eq(200)
      expect(json['sku']).to eq('TEST555')
      expect(json['company_id']).to eq(@client.company_id)
    end

  end

  describe '.update' do
    context 'when record invalid' do
      it 'responds with unprocessed entity error code' do
        TourEntry.any_instance.stub(:update_attributes!).and_raise(ActiveRecord::RecordInvalid.new(TourEntry.new))
        id = my_tour_entries.first.id
        put TOURENTRIESAPI + '/' + id.to_s, tour_entry_params.merge(@auth_details)
        expect(response.status).to eq(422)
      end
    end

    it 'updates a record a given record' do
      id = my_tour_entries.first.id
      put TOURENTRIESAPI + '/' + id.to_s, tour_entry_params.merge(@auth_details)
      expect(response.status).to eq(200)
      expect(json['sku']).to eq 'TEST555'
    end
  end

  describe '.destroy' do
    context 'when destroying our record' do
      it 'deletes a record from a database and returns its id' do
        other_tour_entry
        my_tour_entries

        id = my_tour_entries.first.id
        delete TOURENTRIESAPI + '/' + id.to_s, @auth_details
        expect(TourEntry.where(id: id)).to be_empty
        expect(json['id']).to eq(id)
      end
    end

    context 'when destroying others record' do
      it 'responds with forbidden access code' do
        id = other_tour_entry.id
        delete TOURENTRIESAPI + '/' + id.to_s, @auth_details
        expect(response.status).to eq(403)
        expect(TourEntry.where(id: id)).not_to eq(nil)
      end
    end
  end
end
