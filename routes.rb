resources :galleries, :has_many => :images
resources :gallery_categories
namespace :admin do |admin|
  admin.resources :galleries, :has_many => { :features, :menus }, :collection => { :reorder => :put } do |gallery|
    gallery.resources :images, :member => { :reorder => :put }, :collection => { :reorder => :put, :add_multiple => :get }
    gallery.resources :menus
  end
  admin.resources :gallery_categories, :has_many => { :features, :menus } do |gallery_category|
    gallery_category.resources :menus
    gallery_category.resources :images, :member => { :reorder => :put }, :collection => { :reorder => :put, :add_multiple => :get }
  end

end 
