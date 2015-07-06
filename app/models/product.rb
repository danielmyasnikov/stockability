class Product < ActiveRecord::Base
  # remove product name
  has_and_belongs_to_many :tours
  belongs_to :company

  # validates on 1 company 1 sku
  validates_presence_of :company_id
  validates_uniqueness_of :sku
  has_many :product_barcodes, foreign_key: :sku, primary_key: :sku

  scope :since, -> (since) {
    if since
      where("updated_at > ?", since.to_datetime)
    else
      all
    end
  }

  comma do
    name
  end

  def find_or_initialize_and_create_barcode(barcode_params)
    barcode = product_barcodes.find_by_barcode(barcode_params[:barcode])
    p '.... product ....'
    p barcode
    if barcode
      barcode.update_attributes(barcode_params)
    else
      product_barcodes.create(barcode_params)
    end
  end

end
