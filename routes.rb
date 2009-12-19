resources :galleries, :has_many => :images

namespace :admin do |admin|
  admin.resources :galleries, :has_many => :features, :member => { :reorder => :put } do |gallery|
    gallery.resources :images, :member => { :reorder => :put }, :collection => { :reorder => :put }
  end
end 
