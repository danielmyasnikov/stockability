require 'rails_helper'

RSpec.describe 'Product management', type: :requests do

  describe '.index' do
    let(:my_products)    { FactoryGirl.create_list(:product, 3, company_id: @client.company_id) }
    let(:their_products) { FactoryGirl.create_list(:product, 3, company_id: @client.company_id - 1) }
    let(:product_params) {
      { product: {
        sku: 'TESTSKU23456789'
      } }
    }

    PRODUCTAPI = '/api/v1/products'

    it 'returns products ONLY for my company' do
      # get PRODUCTAPI
    end
  end

  describe '.show'
  describe '.create'
  describe '.update'
  describe '.destroy'
end
