PriceWar::Application.routes.draw do
  match 'product_offers/search' => 'product_offers#search', :as => :search
  root :to => 'product_offers#index'
end
