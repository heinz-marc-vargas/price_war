class Gtin
  include MongoMapper::Document
  has_many :product_offers

  key :gtin, String, :required => true
  key :name, String, :required => true
  timestamps!

  validates_format_of :gtin, :with => /^[-0-9]+$/
  validates_length_of :gtin, :within => 8..14, :allow_blank => false
  validates_presence_of :name
  validates_uniqueness_of :gtin
end
