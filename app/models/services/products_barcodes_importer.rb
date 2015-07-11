class Services::ProductsBarcodesImporter
  attr_reader :errors, :admin, :services, :file, :product
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
        errors << { product[:sku].to_sym => _service.errors }
      end
    end

  end

  def products
    @products ||= []
  end

  def errors
    @errors ||= []
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
      :sku => product[:sku],
      :batch_tracked => product[:batch_tracked],
      :description => product[:description]
    }
  end

end
