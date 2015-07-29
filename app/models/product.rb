class Product < ActiveRecord::Base
  # remove product name
  has_and_belongs_to_many :tours
  belongs_to :company

  # validates on 1 company 1 sku
  validates_presence_of :company_id
  validates_uniqueness_of :sku
  has_many :product_barcodes, foreign_key: :sku, primary_key: :sku

  scope :since, -> (since) { since.present? ? where("updated_at > ?", since.to_datetime) : all }

  # comma do
  #   name
  # end

  def self.sample
    CSV.generate do |csv|
      csv << %w(sku description batch_tracked barcode barcode_description quantity)
      csv << %w(mysqu1 testbla1 1 1 product 50000)
      csv << %w(mysqku3 test 1 555 first_barcode 50004)
      csv << %w(mysqku3 test 1 556 second_barcode 50005)
    end
  end
end
