class Services::ProductBarcodesService
  class NotFound < StandardError; end

  attr_accessor :errors, :product, :product_barcodes, :obj_product, :admin, :barcode

  def initialize(params)

    @admin            = params[:admin]
    @product          = params[:product]
    @product_barcodes = params[:product_barcodes]

    self
  end

  def create
    # consider transactions create discuss with Andrey
    create_product
    create_product_barcodes if allow_continue?
  end

  def update
    if product_exists?
      # consider transactions update discuss with Andrey
      update_product_attributes
      update_barcodes_attributes
    else
      raise NotFound
    end
  end

  def product_exists?
    @obj_product = Product.find_by_sku_and_company_id(product_params[:sku], product_params[:company_id])
    @obj_product.present?
  end

  def errors
    @errors ||= []
  end

private

  def create_product
    begin
      @obj_product = Product.create!(product_params)
      true
    rescue ActiveRecord::RecordInvalid => error
      errors << error
      false
    end
  end

  def update_product_attributes
    obj_product.update_attributes!(product_params)
  rescue ActiveRecord::RecordInvalid => error
    errors << error
  end

  def create_product_barcodes
    product_barcodes.each do |barcode|
      @barcode = barcode
      begin
        obj_product.product_barcodes.create(barcode_params)
      rescue ActiveRecord::RecordInvalid => error
        errors << error
      end
    end
  end

  def update_barcodes_attributes
    product_barcodes.each do |barcode|
      @barcode = barcode
      begin
        find_or_initialize_and_create_barcode(barcode_params)
      rescue ActiveRecord::RecordInvalid => error
        errors << error
      end
    end
  end

  def find_product
    @obj_product = Product.find_by_sku_and_company_id(product_params[:sku], product_params[:company_id])
    if @obj_product.nil?
      errors << 'Not found product by SKU within a company'
      raise NotFound
    end
  end

  def product_params
    {
      name:          product[:name],
      sku:           product[:sku],
      description:   product[:description],
      batch_tracked: product[:batch_tracked],
      company_id:    admin.company_id
    }
  end

  def barcode_params
    {
      barcode:      barcode[:barcode],
      description:  barcode[:description],
      quantity:     barcode[:quantity]
    }
  end

  def allow_continue?
    product_barcodes.present? && product_exists?
  end

  def find_or_initialize_and_create_barcode(barcode_params)
    barcode = obj_product.product_barcodes.find_by_barcode(barcode_params[:barcode])
    if barcode
      barcode.update_attributes!(barcode_params)
    else
      obj_product.product_barcodes.create!(barcode_params)
    end
  end
end
