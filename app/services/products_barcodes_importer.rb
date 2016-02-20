class ProductsBarcodesImporter
  attr_reader :errors, :user, :services, :file, :product, :successfully_imported, :warnings, :products, :barcode

  STATUS = {
    0 => 'Ok',
    1 => 'Warnings',
    2 => 'ERROR: MISSING SKU!'
  }

  def initialize(file, user)
    @file  = file
    @user = user
  end

  def import
    read_file
    validate_data
    parse_data
    save_services
  end

  def display_results
    result = []
    products.each do |prod|
      @product = prod
      if prod.has_key? :product_barcodes
        prod[:product_barcodes].each_with_index do |barcode, index|
          @barcode = barcode
          if index == 0
            result.push(prod_hash)
          else
            result.push(prod_empty_hash)
          end
        end
      end
    end
    result
  end

  def read_file
    @file = CSV.parse(File.read(file), :headers => true)
  end

  def parse_data
    file.each do |ff|
      product = products.select { |x| x[:sku] == ff['sku'] }
      if product.empty?
        product = {}
        product[:sku]              = ff['sku']
        product[:description]      = ff['description']
        product[:batch_tracked]    = ff['batch_tracked']
        product[:product_barcodes] = []
        product[:product_barcodes].push({
          :barcode     => ff["barcode"],
          :description => ff["barcode_description"],
          :quantity    => ff["quantity"] })
        product[:status] = 2 if major_issues?(ff)
        products.push(product)
      else
        product.first[:product_barcodes].push({
          :barcode => ff["barcode"],
          :description => ff["barcode_description"],
          :quantity => ff["quantity"]
        })
      end
    end
  end

  def save_services
    products.each do |product|
      next if product[:status] == 2
      @product = product
      _service = service
      _service.product_exists? ? _service.update : _service.create
      deal_with_errors_warnings_successes(_service)
    end
  end

  def deal_with_errors_warnings_successes(_service)
    case
    when _service.product_failed_on_create
      product[:status]   = 2
      product[:messages] = _service.product_errors
      product[:product_barcodes].map { |barcode| barcode[:status] = 2 }
    when _service.product_failed
      product[:status]   = 1
      product[:messages] = _service.product_errors
    else
      product[:status] = 0
    end
    check_barcodes(_service, product[:product_barcodes])
  end

  def check_barcodes(_service, barcodes)
    define_barcode_status(barcodes)
    if _service.failed_barcodes.present?
      barcodes.each do |_barcode|
        barcode[:barcode_status]   = 2
        barcode[:barcode_messages] = _service.failed_barcodes[barcode[:barcode]]
      end
    end
  end

  def define_barcode_status(barcodes)
    barcodes.map { |barcode| barcode[:barcode_status] = 0 }
  end

  def products
    @products ||= []
  end

  def services
    @services ||= []
  end

private

  def service
    ProductBarcodesService.new({
      :product          => product_params,
      :product_barcodes => product[:product_barcodes],
      :user             => user
    })
  end

  def product_params
    {
      :sku           => product[:sku],
      :batch_tracked => product[:batch_tracked],
      :description   => product[:description]
    }
  end

  def product_message
    {
      :messages => product[:messages],
      :status  => product[:status]
    }
  end

  def barcode_params
    {
      :barcode             => barcode[:barcode],
      :barcode_description => barcode[:description],
      :quantity            => barcode[:quantity]
    }
  end

  def barcode_message
    {
      :barcode_status  => barcode[:barcode_status],
      :barcode_messages => barcode[:barcode_messages]
    }
  end

  def major_issues?(row)
    if row['sku'].nil?
      errors << { 'Missing SKU' => ['Please provide SKU'] }
      return true
    end
  end

  # Product / Product Barcode CSV
  # SKU
  # descritpion
  # batch_tracked
  ## barcode fields
  # barcode
  # barcode_description
  # quantity
  def prod_hash
    result_product = product_params.merge!(product_message)
    result_barcode = barcode_params.merge!(barcode_message)
    hash = result_product.merge(result_barcode)
    hash
  end

  # Product / Product Barcode CSV
  # SKU
  # descritpion
  # batch_tracked
  ## barcode fields
  # barcode
  # barcode_description
  # quantity
  def prod_empty_hash
    result_product = product_params.merge!(product_message)
    result_barcode = barcode_params.merge!(barcode_message)
    hash = result_product.merge!(result_barcode)
    hash[:message]       = nil
    hash[:status]        = nil
    hash[:description]   = nil
    hash[:batch_tracked] = nil
    hash
  end

  def validate_data
    true
  end

  def errors
    @errors ||= []
  end

end
