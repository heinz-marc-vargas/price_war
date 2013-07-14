require 'open-uri'
require 'enumerator'

MAX_SELLERS = 100

class Gtin
  include MongoMapper::Document
    
  has_many :product_offers

  key :gtin, String, :required => true
  key :name, String, :required => true
  timestamps!

  validates_presence_of :gtin, :message => "GTIN can not be blank"
  validates_format_of :gtin, :with => /^[-0-9]+$/, :message => "Invalid GTIN format"
  validates_length_of :gtin, :within => 8..14, :allow_blank => false, :message => "Invalid GTIN format"
  validates_uniqueness_of :gtin
  validate :has_matching_product
  
  def get_offer_list
    url = get_product_info[:url]
    doc = Nokogiri::HTML(open("http://google.com#{url}&os=sellers&prds=num:#{MAX_SELLERS}"))

    doc.css('.online-sellers-row').each do |item|
      base_price = item.css('.base-price')[0].text.strip.gsub(/[^0-9.]/i, '').to_f
      total_price = item.css('.total-col')[0].text.strip.gsub(/[^0-9.]/i, '').to_f
      product_offers << ProductOffer.create(
        :seller_name => item.css('.seller-name')[0].text.strip,
        :base_price => base_price,
        :total_price => (total_price == 0) ? base_price : total_price
      )
    end
  end
  
  def set_product_name
    self.name = get_product_info[:name]
  end
  
  def has_matching_product
    if get_product_info[:url].nil?
      errors[:gtin] << 'No matching products found online'
      return false
    end

    return true
  end
  
  def get_product_info
    product_info = Hash.new
    doc = Nokogiri::HTML(open("http://www.google.com/search?tbm=shop&q=#{gtin}"))
    product_info = {
      :name => (doc.xpath('//h3/a').children.first.text rescue nil),
      :url => (doc.xpath('//h3/a').first['href'] rescue nil) } #TODO: drink more coffee and clean this up!
    return product_info
  end

end
