class Services::StockLevelImporter
  attr_reader :errors, :admin, :services, :file, :product, :importer_row
              :successfully_imported, :warnings, :products, :barcode

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
    save_data
  end

  def display_results
    result = []
  end

  def importer_row
    @importer_row ||= {}
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
      importer_row = row
    end
  end

  def stock_level_params
    {
      sku:        importer_row[:sku],
      batch_code: importer_row[:batch_code],
      quantity:   importer_row[:quantity]
    }
  end

  def bin_params
    {
      title:    importer_row[:bin_title],
      location: importer_row[:location_code]
    }
  end

  def location_params
    {
      code: importer_row[:location_code]
    }
  end
end
