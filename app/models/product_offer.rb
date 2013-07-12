class ProductOffer
  include MongoMapper::Document

  belongs_to :gtin

  key :seller_name, String, :required => true
  key :base_price, Float, :required => true
  key :total_price, Float, :required => true
  timestamps!

  validates_numericality_of :base_price
  validates_numericality_of :total_price
  validates_presence_of :seller_name
end
