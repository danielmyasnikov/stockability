require 'rails_helper'

RSpec.describe 'Product Barcoes Management API', type: :request do

  let(:product) { FactoryGirl.create(:product, company_id: @client.company_id) }
  let(:my_product_barcodes) { FactoryGirl.create_list(:product_barcode, 3, company_id: @client.company_id, product: product) }
  let(:their_product_barcodes) { FactoryGirl.create(:product_barcode, company_id: @client.company_id + 1) }

  let(:product_barcode_params) {
    {
      product_barcode: {
        sku:     product.sku,
        barcode: 'ZYX987',
        quantity: 55
      }
    }
  }

  before :all do; BARCODESAPI = '/api/v1/product_barcodes'; end

  # why instance variables?
  before :each do
    @client       ||= FactoryGirl.create(:user, :company_admin)
    @auth_details = { auth: { token: @client.token } }
  end

  context 'when unauthorized access' do
    it 'responds with forbidden access 403' do
      get    BARCODESAPI;         expect(response.status).to eq(403)
      get    BARCODESAPI + '/1';  expect(response.status).to eq(403)
      post   BARCODESAPI;         expect(response.status).to eq(403)
      put    BARCODESAPI + '/1';  expect(response.status).to eq(403)
      delete BARCODESAPI + '/1';  expect(response.status).to eq(403)
    end
  end


  describe '.index' do
    subject { get BARCODESAPI, @auth_details }

    it 'display company records' do
      my_product_barcodes
      their_product_barcodes

      subject

      json_ids = parsed_json.map { |x| x['id'] }
      product_barcode_ids = my_product_barcodes.map(&:id)

      expect(response.status).to be(200)
      expect(json_ids).to eq(product_barcode_ids)
    end

    it 'does not display other companies record' do
      my_product_barcodes
      their_product_barcodes

      subject

      json_ids = parsed_json.map { |x| x['id'] }
      includes = json_ids.include?(their_product_barcodes.id)

      expect(response.status).to be(200)
      expect(includes).to be(false)
    end
  end

  describe '.show' do
    context 'when accessing their records' do
      it 'responds with forbidden access' do
        id = their_product_barcodes.id
        get BARCODESAPI + '/' + id.to_s, @auth_details
        expect(response.status).to eq(403)
        expect(json['id']).to eq(nil)
      end
    end

    it 'renders a valid tour object' do
      id = my_product_barcodes.first.id
      get BARCODESAPI + '/' + id.to_s, @auth_details
      expect(response.status).to eq(200)
      expect(json['id']).to eq(id)
    end
  end

  describe '.create' do
    subject { post BARCODESAPI, @auth_details.merge(product_barcode_params) }
    context 'when invalid record' do
      it 'renders unprocessed entity' do
        ProductBarcode.stub(:create!).and_raise(ActiveRecord::RecordInvalid.new(Tour.new))
        subject
        expect(response.status).to eq(422)
        expect(json['barcode']).to eq(nil)
      end
    end

    it 'creates a record for a company' do
      subject
      expect(response.status).to eq(200)
      expect(json['barcode']).to eq('ZYX987')
    end
  end

  describe '.update' do
    context 'when updating their record' do
      it 'responds with forbidden access' do
        id = their_product_barcodes.id
        put BARCODESAPI + '/' + id.to_s, @auth_details.merge(product_barcode_params)
        expect(response.status).to eq(403)
      end
    end

    context 'when invalid record' do
      it 'renders unprocessed entity' do
        ProductBarcode.any_instance.stub(:update_attributes!).and_raise(ActiveRecord::RecordInvalid.new(ProductBarcode.new))
        id = my_product_barcodes.first.id
        put BARCODESAPI + '/' + id.to_s, @auth_details.merge(product_barcode_params)
        expect(response.status).to eq(422)
      end
    end

    it 'updates the record and returns the record' do
      id = my_product_barcodes.first.id
      put BARCODESAPI + '/' + id.to_s, @auth_details.merge(product_barcode_params)
      expect(response.status).to eq(200)
      expect(json['id']).to eq(id)
      expect(json['barcode']).to eq('ZYX987')
    end
  end

  describe '.destroy' do
    context 'when destroying other tour' do
      it 'responds with forbidden access' do
        id = their_product_barcodes.id
        delete BARCODESAPI + '/' + id.to_s, @auth_details
        expect(response.status).to eq(403)
        expect(json['id']).to eq(nil)
        expect(ProductBarcode.where(id: id).present?).to be(true)
      end
    end

    it 'destroys the record and returns the instance' do
      id = my_product_barcodes.first.id
      delete BARCODESAPI + '/' + id.to_s, @auth_details
      expect(response.status).to eq(200)
      expect(json['id']).to eq(id)
      expect(ProductBarcode.where(id: id).present?).to be(false)
    end
  end
end
