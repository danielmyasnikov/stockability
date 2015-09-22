require 'rails_helper'

RSpec.describe Services::ProductBarcodesService, :type => :services do
  before :each do
    @admin = FactoryGirl.create(:admin, :company_admin)
  end

  let(:product_params) { { sku: 'ABC123', batch_tracked: 1, description: 'test product #1' } }
  let(:barcode_params) { [{barcode: 'ZYX987', quantity: 3}, {barcode: 'SDF555', quantity: 4}] }
  let(:service) { Services::ProductBarcodesService.new(params) }

  context 'successfully servicing the only product' do

    let(:params) { {product: product_params, product_barcodes: [], admin: @admin} }
    subject { service.create }

    it 'creates a product' do
      subject
      expect(Product.find_by_sku('ABC123')).to eq(service.obj_product)
    end

    it 'does not record product failure' do
      subject
      expect(service.product_errors).to eq([])
      expect(service.product_failed).to be_falsey
      expect(service.product_failed_on_create).to be_falsey
    end

    it 'does not record barcode failure' do
      subject
      expect(service.failed_barcodes).to eq({})
      expect(service.barcode_errors).to eq([])
    end
  end

  context 'successfully servicing a product with barcodes' do
    let(:params) { {product: product_params, product_barcodes: barcode_params, admin: @admin} }
    subject { service.create }

    it 'creates a product with product barcodes' do
      subject
      product = Product.find_by_sku('ABC123')
      expect(product).to eq(service.obj_product)
      expect(product.product_barcodes).to eq(service.obj_product.product_barcodes)
      expect(product.product_barcodes.first.barcode).to eq(barcode_params.first[:barcode])
    end

    it 'does not record product failure' do
      subject
      expect(service.product_errors).to eq([])
      expect(service.product_failed).to be_falsey
      expect(service.product_failed_on_create).to be_falsey

    end

    it 'does not record barcode failure' do
      subject
      expect(service.failed_barcodes).to eq({})
      expect(service.barcode_errors).to eq([])
    end
  end

  context 'successfully updating a product service with barcodes' do
    let(:params) { {product: product_params, product_barcodes: barcode_params, admin: @admin} }
    subject { service.update }

    before :each do
      product = FactoryGirl.create(:product, :company => @admin.company)
      product.product_barcodes << FactoryGirl.create(:product_barcode)
    end

    it 'updates a product with new product parameters' do
      subject
      product = Product.find_by_sku('ABC123')
      expect(product).to eq(service.obj_product)
      expect(product.product_barcodes).to eq(service.obj_product.product_barcodes)
      expect(product.product_barcodes.where(barcode: 'ZYX987').first.quantity).to eq(barcode_params.first[:quantity])
    end

    it 'does not record product failure' do
      subject
      expect(service.product_errors).to eq([])
      expect(service.product_failed).to be_falsey
      expect(service.product_failed_on_create).to be_falsey
    end

    it 'does not record barcode failure' do
      subject
      expect(service.failed_barcodes).to eq({})
      expect(service.barcode_errors).to eq([])
    end
  end

  context 'initial product service creation fails' do
    let(:params) { {product: product_params, product_barcodes: barcode_params, admin: @admin} }
    subject { service.create }

    before :each do
      Product.stub(:create!).and_raise(ActiveRecord::RecordInvalid.new(Product.new))
    end

    it 'fails to create a product' do
      subject
      product = Product.find_by_sku('ABC123')
      expect(product).to be_nil
      expect(service.obj_product).to be_nil
    end

    it 'records a product failure' do
      subject
      expect(service.product_errors.size).to eq(1)
      expect(service.product_failed_on_create).to be(true)
    end

    it 'does not record barcode failure' do
      subject
      expect(service.failed_barcodes).to eq({})
      expect(service.barcode_errors).to eq([])
    end

    it 'does not create barcodes' do
      barcode = ProductBarcode.find_by_barcode('ZYX987')
      expect(barcode).to be_nil
    end
  end

  context 'successfull product creation, but product barcodes failure' do
    let(:barcode_params) { [{ barcode: 'JYZ789' }] }
    let(:params) { {product: product_params, product_barcodes: barcode_params, admin: @admin} }
    subject { service.create }

    it 'creates a product' do
      subject
      product = Product.find_by_sku('ABC123')
      expect(service.obj_product).to eq(product)
    end

    xit 'records barcode failure' do
      # subject
      # barcode = ProductBarcode.create(barcode_params.first)
      # missing_quantity_error_message = ActiveRecord::RecordInvalid.new(barcode).message
      # expect(service.failed_barcodes.keys).to eq( ['JYZ789'] )
      # expect(service.failed_barcodes.values.first.first.message).to eq( "Validation failed: Quantity can't be blank" )
      # expect(service.barcode_errors.first.message).to eq("Validation failed: Quantity can't be blank")
    end
  end

  xcontext 'updating a service' do
    context 'when product fails but barcode updates successfully'
    context 'when product successfull updates but barcode fails'
    context 'product and barcodes update fails'
  end
end
