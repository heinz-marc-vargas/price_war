class ProductOffersController < ApplicationController

  def index
  end

  def search
    searcher = GoogleShoppingParser.new
    @results = searcher.get_offer_list(params[:gtin])

    respond_to do |format|
      format.js
    end
  end
end

