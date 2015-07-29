class Services::StockLevelsImporter
  attr_reader :errors, :admin, :file, :imported_row, :stock_level,
              :successfully_imported, :warnings, :location, :bin, :product, :results

  STATUS = {
    0 => 'OK',
    1 => 'WARNINGS',
    2 => 'ERROR'
  }

  def initialize(file, admin)
    @file  = file
    @admin = admin
  end

  def import
    parse_file
    validate_data
    normalize_data
  end

  def results
    @results ||= []
  end

  def imported_row
    @imported_row ||= {}
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
        p row
        p imported_row[:sku]
        @location    = Location.find_or_initialize_by(location_params)
        p @location
        @bin         = Bin.find_or_initialize_by(bin_params)
        @product     = Product.find_or_initialize_by(product_params)
        @stock_level = StockLevel.find_or_initialize_by(stock_level_params)
        save_data
      end
    end
  end

  def save_data
    # define biz rules
    p @location
    @location.save
    @bin.save
    @product.save
    @stock_level.save

    p ">>>> RESULT <<<<"
    p import_params
    p results

    @results.push(import_params)
  end

  def stock_level_params
    {
      sku:           imported_row[:sku],
      batch_code:    imported_row[:batch_code],
      quantity:      imported_row[:quantity],
      bin_code:      imported_row[:bin_code],
      location_code: imported_row[:location_code],
      company_id:    admin.company_id
    }
  end

  def product_params
    {
      sku:        imported_row[:sku],
      company_id: admin.company_id
    }
  end

  def bin_params
    {
      code:          imported_row[:bin_code],
      location_code: imported_row[:location_code],
      company_id:    admin.company_id
    }
  end

  def location_params
    {
      code:       imported_row[:location_code],
      company_id: admin.company_id
    }
  end

  def import_params
    {
      sku: imported_row[:sku],
      batch_code: imported_row[:batch_code],
      quantity: imported_row[:quantity],
      bin_code: imported_row[:bin_code],
      location_code: imported_row[:location_code]
    }
  end
end
