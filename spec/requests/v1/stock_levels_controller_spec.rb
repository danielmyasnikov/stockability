require 'rails_helper'

# candite for refactor
RSpec.describe 'StockLevels API', type: :request do

  let(:my_stock_levels)    { FactoryGirl.create_list(:stock_level, 3, :company_id => @client.company_id) }
  let(:other_stock_levels) { FactoryGirl.create(:stock_level, :company_id => @client.company_id + 1) }

  before :all do; STOCKLEVELAPI = '/api/v1/stock_levels'; end

  before :each do
    @client             = FactoryGirl.create(:user, :company_admin)
    @auth_details       = { auth: { token: @client.token } }
  end

  context 'when unauthorized access' do
    it 'responds with forbidden access 403' do
      get    STOCKLEVELAPI;    expect(response.status).to eq(403)
      get    STOCKLEVELAPI + '/1';  expect(response.status).to eq(403)
      post   STOCKLEVELAPI;    expect(response.status).to eq(403)
      put    STOCKLEVELAPI + '/1';  expect(response.status).to eq(403)
      delete STOCKLEVELAPI + '/1';  expect(response.status).to eq(403)
    end
  end

  describe '.index' do
    # It's a good idea to test the correct behaviour of the index action
    # That must look like tests are written to check cancancan behaviour
    # However it's a good idea to double check the behavour all together
    it 'does not display stock levels from a different company' do
      my_stock_levels
      other_stock_levels

      get STOCKLEVELAPI, @auth_details

      includes = parsed_json.map { |x| x['id'] }.include? other_stock_levels.id
      expect(includes).to be(false)
    end

    it 'displays only stock levels from client company' do
      my_stock_levels
      other_stock_levels
      get STOCKLEVELAPI, @auth_details
      json_ids = parsed_json.map { |x| x['id'] }
      prod_ids = my_stock_levels.map(&:id)

      expect(json_ids).to eq(prod_ids)
    end
  end

  describe '.show' do
    context 'when accessing own stock levels' do
      it 'displays stock level' do
        my_stock_levels
        other_stock_levels
        get STOCKLEVELAPI + '/' + my_stock_levels.first.id.to_s, @auth_details
        expect(json['id']).to eq(my_stock_levels.first.id)
      end
    end

    context 'when accessing theirs stock levels' do
      it 'returns forbidden response' do
        my_stock_levels
        other_stock_levels

        get STOCKLEVELAPI + '/' + other_stock_levels.id.to_s, @auth_details
        expect(response.status).to eq(403)
      end
    end
  end

  describe '.create' do
    let!(:location) { FactoryGirl.create(:location, code: 'LOC445', company_id: @client.company_id) }
    let(:stock_level_params) {
         { stock_level: {
          bin_code: 'BIN111',
          sku: 'TEST555',
          batch_code: 'HELLOWORLD',
          quantity: 1,
          location_code: 'LOC445'
        }
      }
    }

    it 'creates a stock levels' do
      post_params = @auth_details.merge(stock_level_params)
      post STOCKLEVELAPI, post_params
      expect(json['sku']).to eq(stock_level_params[:stock_level][:sku])
      expect(response.status).to eq(200)
    end

    context 'when record invalid' do
      it 'responds with 422' do
        StockLevel.stub(:create!).and_raise(ActiveRecord::RecordInvalid.new(StockLevel.new))
        post_params = @auth_details.merge(stock_level_params)
        post STOCKLEVELAPI, post_params
        expect(response.status).to eq(422)
      end
    end
  end

  describe '.update' do
    let(:stock_level_params) {
      { stock_level: {
          bin_code: 'BIN111',
          sku: 'TEST555',
          batch_code: 'HELLOWORLD',
          quantity: 1,
          location_code: 'LOC445',
        }
      }
    }
    context 'when accessing own stock levels' do
      it 'updates stock level' do
        my_stock_levels
        other_stock_levels
        id = my_stock_levels.first.id.to_s
        put STOCKLEVELAPI + '/' + id, @auth_details.merge(stock_level_params)

        expect(json['id'].to_s).to eq(id)
        expect(Product.where(id: 1)).to be_empty
      end
    end

    context 'when accessing theirs stock levels' do
      it 'returns forbidden response' do
        my_stock_levels
        other_stock_levels

        put STOCKLEVELAPI + '/' + other_stock_levels.id.to_s, @auth_details.merge(stock_level_params)
        expect(response.status).to eq(403)
        expect(json['sku']).not_to eq('TEST555')
      end
    end

    context 'when record invalid' do
      it 'responds with 422' do
        my_stock_levels
        other_stock_levels

        StockLevel.any_instance.stub(:update_attributes!).and_raise(ActiveRecord::RecordInvalid.new(StockLevel.new))
        post_params = @auth_details.merge(stock_level_params)
        put STOCKLEVELAPI + '/' + my_stock_levels.first.id.to_s, post_params
        expect(response.status).to eq(422)
      end
    end
  end

  describe '.destroy' do
    context 'when accessing own stock levels' do
      it 'displays stock level' do
        my_stock_levels
        other_stock_levels

        id = my_stock_levels.first.id

        delete STOCKLEVELAPI + '/' + id.to_s, @auth_details

        expect(json['id']).to eq(id)
        expect(Product.where(id: id)).to be_empty
      end
    end

    context 'when accessing theirs stock levels' do
      it 'returns forbidden response' do
        my_stock_levels
        other_stock_levels
        id = other_stock_levels.id.to_s
        delete STOCKLEVELAPI + '/' + id, @auth_details
        expect(response.status).to eq(403)
        expect(Product.where(id: id)).not_to eq(nil)
      end
    end
  end
end
