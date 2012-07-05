class GalleryCategory < ActiveRecord::Base
  has_permalink :title
  has_many :galleries
  belongs_to :template
  belongs_to :column
  has_many :features, :as => :featurable, :dependent => :destroy
  has_many :images, :as => :viewable, :dependent => :destroy
  has_many :menus, :as => :navigatable, :dependent => :destroy
  named_scope :active, :conditions => { :active => true }
  default_scope :conditions => { :active => true }
  def to_param
    "#{self.id}-#{self.permalink}"
  end  
end