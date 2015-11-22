class Services::ProductBarcodesService
  class NotFound < StandardError; end

  attr_accessor :product_errors, :barcode_errors, :product, :product_barcodes,
    :obj_product, :user, :barcode, :product_failed, :failed_barcodes,
    :product_failed_on_create


  def initialize(params)
    @user             = params[:user]
    @product          = params.fetch(:product)
    @product_barcodes = params.fetch(:product_barcodes, [])

    self
  end

  def create
    create_product
    create_product_barcodes if allow_continue?
  end

  def update
    if product_exists?
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

  def product_errors
    @product_errors ||= []
  end

  def barcode_errors
    @barcode_errors ||= []
  end

  def failed_barcodes
    @failed_barcodes ||= {}
  end

private

  def create_product
    begin
      @obj_product = Product.create!(product_params)
      true
    rescue ActiveRecord::RecordInvalid => error
      product_errors << error
      record_product_failure
      false
    end
  end

  def create_product_barcodes
    product_barcodes.each do |barcode|
      @barcode = barcode
      begin
        obj_product.product_barcodes.create!(barcode_params)
      rescue ActiveRecord::RecordInvalid => error
        barcode_errors << error
        record_barcode_failure
      end
    end
  end

  def update_product_attributes
    obj_product.update_attributes!(product_params)
  rescue ActiveRecord::RecordInvalid => error
    product_errors << error
    record_product_failure
  end

  def update_barcodes_attributes
    product_barcodes.each do |barcode|
      @barcode = barcode
      begin
        find_or_initialize_and_create_barcode(barcode_params)
      rescue ActiveRecord::RecordInvalid => error
        barcode_errors << error
        record_barcode_failure
      end
    end
  end

  def find_product
    @obj_product = Product.find_by_sku_and_company_id(product_params[:sku], product_params[:company_id])
    if @obj_product.nil?
      product_errors << 'Not found product by SKU within a company'
      raise NotFound
    end
  end

  def product_params
    {
      sku:           product[:sku],
      description:   product[:description],
      batch_tracked: product[:batch_tracked],
      company_id:    user.company_id
    }
  end

  def barcode_params
    {
      barcode:     barcode[:barcode],
      description: barcode[:description],
      quantity:    barcode[:quantity],
      company_id:  user.company_id
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

  def record_product_failure(on_create = true)
    if on_create
      @product_failed_on_create = true
    else
      @product_failed = true
    end
  end

  def record_barcode_failure
    failed_barcodes.merge!(barcode[:barcode] => barcode_errors)
  end
end
