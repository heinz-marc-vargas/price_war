class ProductOffersController < ApplicationController

  def index
  end

  def search
    @record = Gtin.find_by_gtin(params[:gtin])
    if @record.nil?
      @record = Gtin.new
      @record.gtin = params[:gtin]
      @record.set_product_name
      if @record.save
        @record.get_offer_list
      end
    end
    
    respond_to do |format|
      format.js
    end
  end
end
