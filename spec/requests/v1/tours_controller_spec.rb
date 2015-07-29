require 'rails_helper'

RSpec.describe 'Tours Management API', type: :request do

  let(:my_tours) { FactoryGirl.create_list(:tour, 3, company_id: @client.company_id) }
  let(:their_tour) { FactoryGirl.create(:tour, company_id: @client.company_id + 1) }
  let(:tour_params) {
    {
      tour: {
        name: 'TESTABC777'
      }
    }
  }

  before :all do; TOURSAPI = '/api/v1/tours'; end

  before :each do
    @client       ||= FactoryGirl.create(:admin, :company_admin)
    @auth_details = { auth: { token: @client.token } }
  end

  context 'when unauthorized access' do
    it 'responds with forbidden access 403' do
      get    TOURSAPI;         expect(response.status).to eq(403)
      get    TOURSAPI + '/1';  expect(response.status).to eq(403)
      post   TOURSAPI;         expect(response.status).to eq(403)
      put    TOURSAPI + '/1';  expect(response.status).to eq(403)
      delete TOURSAPI + '/1';  expect(response.status).to eq(403)
    end
  end


  describe '.index' do
    subject { get TOURSAPI, @auth_details }

    it 'display company records' do
      my_tours
      their_tour

      subject

      json_ids = parsed_json.map { |x| x['id'] }
      tour_ids = my_tours.map(&:id)

      expect(response.status).to be(200)
      expect(json_ids).to eq(tour_ids)
    end

    it 'does not display other companies record' do
      my_tours
      their_tour

      subject

      json_ids = parsed_json.map { |x| x['id'] }
      includes = json_ids.include?(their_tour.id)

      expect(response.status).to be(200)
      expect(includes).to be(false)
    end
  end

  describe '.show' do
    context 'when accessing their records' do
      it 'responds with forbidden access' do
        id = their_tour.id
        get TOURSAPI + '/' + id.to_s, @auth_details
        expect(response.status).to eq(403)
        expect(json['id']).to eq(nil)
      end
    end

    it 'renders a valid tour object' do
      id = my_tours.first.id
      get TOURSAPI + '/' + id.to_s, @auth_details
      expect(response.status).to eq(200)
      expect(json['id']).to eq(id)
    end
  end

  describe '.create' do
    subject { post TOURSAPI, @auth_details.merge(tour_params) }
    context 'when invalid record' do
      it 'renders unprocessed entity' do
        Tour.stub(:create!).and_raise(ActiveRecord::RecordInvalid.new(Tour.new))
        subject
        expect(response.status).to eq(422)
        expect(json['name']).to eq(nil)
      end
    end

    it 'creates a record for a company' do
      subject
      expect(response.status).to eq(200)
      expect(json['name']).to eq('TESTABC777')
    end
  end

  describe '.update' do
    context 'when updating their record' do
      it 'responds with forbidden access' do
        id = their_tour.id
        put TOURSAPI + '/' + id.to_s, @auth_details.merge(tour_params)
        expect(response.status).to eq(403)
      end
    end

    context 'when invalid record' do
      it 'renders unprocessed entity' do
        Tour.any_instance.stub(:update_attributes!).and_raise(ActiveRecord::RecordInvalid.new(Tour.new))
        id = my_tours.first.id
        put TOURSAPI + '/' + id.to_s, @auth_details.merge(tour_params)
        expect(response.status).to eq(422)
      end
    end

    it 'updates the record and returns the record' do
      id = my_tours.first.id
      put TOURSAPI + '/' + id.to_s, @auth_details.merge(tour_params)
      expect(response.status).to eq(200)
      expect(json['id']).to eq(id)
      expect(json['name']).to eq('TESTABC777')
    end
  end

  describe '.destroy' do
    context 'when destroying other tour' do
      it 'responds with forbidden access' do
        id = their_tour.id
        delete TOURSAPI + '/' + id.to_s, @auth_details
        expect(response.status).to eq(403)
        expect(json['id']).to eq(nil)
        expect(Tour.where(id: id).present?).to be(true)
      end
    end

    it 'destroys the record and returns the instance' do
      id = my_tours.first.id
      delete TOURSAPI + '/' + id.to_s, @auth_details
      expect(response.status).to eq(200)
      expect(json['id']).to eq(id)
      expect(Tour.where(id: id).present?).to be(false)
    end
  end
end
