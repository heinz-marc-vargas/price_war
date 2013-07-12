require 'open-uri'

class GoogleShoppingParser
  include MongoMapper::Document

  def get_offer_list(gtin)
    product_url = get_product_url(gtin)
    
    doc = Nokogiri::HTML(open("http://google.com#{product_url}"))

    offers = []
    doc.css('.online-sellers-row').each do |item|
      base_price = item.css('.base-price')[0].text.strip.gsub(/[^0-9.]/i, '').to_f
      total_price = item.css('.total-col')[0].text.strip.gsub(/[^0-9.]/i, '').to_f
      offers << {
        :seller_name => item.css('.seller-name')[0].text.strip,
        :base_price => base_price,
        :total_price => (total_price == 0) ? base_price : total_price
      }
    end

    return offers
  end
  
  private
  
  def get_product_url(gtin)
    doc = Nokogiri::HTML(open("http://www.google.com/search?tbm=shop&q=#{gtin}"))
    @product_name = doc.xpath('//h3/a').children.first.text
    return doc.xpath('//h3/a').first['href'] rescue '' #TODO: drink more coffee and clean this up!
  end

  def get_amazon_matches(product_name)
    doc = Nokogiri::HTML(open("http://www.amazon.com/s/ref=nb_sb_noss?url=search-alias&field-keywords=#{product_name}"))
    return doc.xpath('//h3/a')[0]['href'] rescue ''
     
  end
end