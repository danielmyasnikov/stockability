class Services::ProductBarcodesService
  attr_accessor :errors, :product, :product_barcodes

  def initialize(product, product_barcodes_params = [], current_admin = nil)
    @product         = product
    @product.company ||= current_admin.company

    product_barcodes_params.fetch(:product_barcodes).each do |barcode|
      product_barcodes << @product.product_barcodes.new(barcode)
    end

    self
  end

  def product_barcodes
    @product_barcodes ||= []
  end

  def save
    if product.save
      if product_barcodes.map(&:save)
        true
      else
        @errors = product_barcodes.map(&:errors).flatten.compact
      end
    else
      @errors = product.errors
      false
    end
  end

  def self.find(product)
    @product = Product.find_by_sku(product.sku)
    raise NotFound if @product.nil?

    Services::ProductBarcodesService.new(@product)
  end

  def update_attributes(product_params, barcode_params = [])
    product.update_attributes product_params.reject { |x| x == :product_barcodes }

    barcode_params.fetch(:product_barcodes).each do |barcode|
      product_barcode = @product.product_barcodes.find_or_initialize_by(:barcode => barcode[:barcode])
      begin
        product_barcode.update_attributes(barcode)
      rescue ActiveRecord::RecordInvalid
        errors << product_barcode.errors
      end
    end
  end

  def errors
    @errors ||= []
  end

  class NotFound < StandardError; end
end
