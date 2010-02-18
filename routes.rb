resources :galleries, :has_many => :images

namespace :admin do |admin|
  admin.resources :galleries, :has_many => { :features, :menus }, :collection => { :reorder => :put } do |gallery|
    gallery.resources :images, :member => { :reorder => :put }, :collection => { :reorder => :put }
    gallery.resources :menus
  end
end 
