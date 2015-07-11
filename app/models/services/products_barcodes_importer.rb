class Services::ProductsBarcodesImporter
  attr_reader :errors, :admin, :services, :file, :product, :successfully_imported, :warnings
  def initialize(file, admin)
    @file  = file
    @admin = admin
  end

  def import
    read_file
    parse_file
    load_services
    save_services
  end

  def read_file
    @file = CSV.parse(File.read(file), :headers => true)
  end

  def parse_file
    file.each do |ff|
      next if major_issues?(ff)
      product = products.select { |x| x[:sku] == ff['sku'] }
      if product.empty?
        product = {}
        product[:sku] = ff['sku']
        product[:description] = ff['description']
        product[:batch_tracked] = ff['batch_tracked']
        product[:product_barcodes] = []
        product[:product_barcodes].push({ :barcode => ff["barcode"], :description => ff["barcode_description"], :quantity => ff["quantity"] })
        products.push(product)
      else
        product.first[:product_barcodes].push({ :barcode => ff["barcode"], :description => ff["barcode_description"], :quantity => ff["quantity"] })
      end
    end
  end

  def load_services
    products.each do |product|
      @product = product
      services.push(
        service.new({
          :product => product_params,
          :product_barcodes => product[:product_barcodes],
          :admin => admin
        })
      )
    end
  end

  def save_services
    services.each do |_service|
      _service.product_exists? ? _service.update : _service.create
      if _service.errors.present?
        warnings << { _service.obj_product.sku => _service.errors }
      else
        successfully_imported << { _service.obj_product.sku => ['Successfully imported product and product barcodes'] }
      end
    end

  end

  def successfully_imported
    @successfully_imported ||= []
  end

  def products
    @products ||= []
  end

  def errors
    @errors ||= []
  end

  def warnings
    @warnings ||= []
  end

  def services
    @services ||= []
  end

private

  def service
    Services::ProductBarcodesService
  end

  def product_params
    {
      :sku           => product[:sku],
      :batch_tracked => product[:batch_tracked],
      :description   => product[:description]
    }
  end

  def major_issues?(row)
    if row['sku'].nil?
      errors << { 'Missing SKU' => ['Please provide SKU'] }
      return true
    end
    if row['barcode'].nil?
      errors << { 'Missing barcode number' => ['Please provide barcode number'] }
      return true
    end
  end

end
