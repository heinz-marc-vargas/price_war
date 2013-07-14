require 'spec_helper'

describe Gtin do
  # 00047875327375 - Doom Collector's Ediion (PC)
  valid_gtin = '00047875327375'
  
  it "is invalid if it is less than 8 numbers" do
    Gtin.create(:gtin => '1234567').should_not be_valid
  end
  
  it "is invalid if it is more than 12 numbers" do
    Gtin.create(:gtin => '11223344556677').should_not be_valid
  end

  it "is invalid if it contains non-numeric characters" do
    Gtin.create(:gtin => '1234567abc').should_not be_valid
  end
  
  it "has a matching product URL" do
    gtin = Gtin.new(:gtin => valid_gtin)
    gtin.get_product_info[:url].should_not eq(nil)
  end

  it "has a matching product name" do
    gtin = Gtin.new(:gtin => valid_gtin)
    gtin.get_product_info[:name].should_not eq(nil)
  end
  
  it "has a collection of seller/offer records" do
    Gtin.first.product_offers.should_not eq(nil)
  end

end
