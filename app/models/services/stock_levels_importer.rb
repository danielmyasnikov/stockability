class Services::StockLevelsImporter
  cattr_reader :results
  attr_reader :errors, :user, :file, :imported_row, :stock_level, :custom_errors,
              :successfully_imported, :warnings, :location, :product

  STATUS = {
    0 => 'OK',
    1 => 'WARNINGS',
    2 => 'ERROR'
  }

  def self.nullify_results
    @@results = []
  end

  def self.results
    @@results ||= []
  end

  def initialize(file, user)
    @file  = file
    @user = user
  end

  def import
    parse_file
    validate_data
    normalize_data
  end

private

  def parse_file
    @file = CSV.parse(File.read(file), :headers => true)
  end

  def validate_data
    true
  end

  def normalize_data
    file.each do |row|
      if @imported_row = HashWithIndifferentAccess.new(row)
        @custom_errors = nil
        @location      = Location.find_by(location_params)
        @product       = Product.find_or_initialize_by(product_params)
        @stock_level   = StockLevel.new(stock_level_params)
        save_data
      end
    end
  end

  def save_data
    if @location.try(:valid?) && @product.save
      @stock_level.save
    else
      @custom_errors = 'Location or Product have issues'
    end
    Services::StockLevelsImporter.results.push(import_params)
  end

  def stock_level_params
    {
      sku:           imported_row[:sku],
      batch_code:    imported_row[:batch_code],
      quantity:      imported_row[:quantity],
      bin_code:      imported_row[:bin_code],
      location_code: imported_row[:location_code],
      company_id:    user.company_id
    }
  end

  def product_params
    {
      sku:        imported_row[:sku],
      company_id: user.company_id
    }
  end

  def location_params
    {
      code:       imported_row[:location_code],
      company_id: user.company_id
    }
  end

  def import_params
    {
      sku:           imported_row[:sku],
      batch_code:    imported_row[:batch_code],
      quantity:      imported_row[:quantity],
      bin_code:      imported_row[:bin_code],
      location_code: imported_row[:location_code],
      errors:        errors
    }
  end

  def errors
    if custom_errors
      custom_errors
    else
      import_errors(location, product, stock_level)
    end
  end

  def imported_row
    @imported_row ||= {}
  end

  def import_errors(*items)
    _errors = ''
    items.each do |item|
      if import_error(item)
        _errors << import_error(item)
      end
    end
    _errors
  end

  def import_error(item)
    if item.errors.present?
      item.errors.full_messages.join(', ')
    end
  end
end
