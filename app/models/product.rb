class Product < ActiveRecord::Base
  # remove product name
  has_and_belongs_to_many :tours
  belongs_to :company

  # validates on 1 company 1 sku
  validates_presence_of :company_id
  validates_uniqueness_of :sku
  has_many :product_barcodes, foreign_key: :sku, primary_key: :sku

  scope :since, -> (since) { since.present? ? where("updated_at > ?", since.to_datetime) : all }

  comma do
    name
  end
end
