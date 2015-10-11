class Product < ActiveRecord::Base
  has_and_belongs_to_many :tours
  belongs_to :company
  has_many :product_barcodes, -> (product) {
    where("product_barcodes.company_id = :company_id",
      company_id: product.company_id)
    },
  foreign_key: :sku, primary_key: :sku, dependent: :destroy

  # TODO: apply to all other entities
  has_many :stock_levels, -> (product) {
    where("stock_levels.company_id = :company_id",
      company_id: product.company_id)
    },
  foreign_key: :sku, primary_key: :sku, dependent: :destroy

  validates_presence_of :company_id
  validates :sku, uniqueness: {
    scope: [:company_id], message: 'Product is is not unique within a company.'
  }

  scope :since, -> (since) { since.present? ? where("updated_at > ?", since.to_datetime) : all }

  def self.sample
    CSV.generate do |csv|
      csv << %w(sku description batch_tracked barcode barcode_description quantity)
      csv << %w(mysqu1 testbla1 1 1 product 50000)
      csv << %w(mysqku3 test 1 555 first_barcode 50004)
      csv << %w(mysqku3 test 1 556 second_barcode 50005)
    end
  end

  def self.to_csv(products)
    CSV.generate do |csv|
      csv << %w(sku description batch_tracked barcode description quantity)
      products.each do |product|
        if product.product_barcodes.present?
          product.product_barcodes.each_with_index do |barcode, index|
            if index == 0
              csv << [product.sku, product.description, product.batch_tracked, barcode.barcode, barcode.description, barcode.quantity]
            else
              csv << [nil, nil, nil, barcode.barcode, barcode.description, barcode.quantity]
            end
          end
        else
          csv << [product.sku, product.description, product.batch_tracked, nil, nil, nil]
        end
      end
    end
  end

  def option_title
    name.to_s + ' ' + sku
  end
end
