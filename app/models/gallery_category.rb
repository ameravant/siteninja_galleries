class GalleryCategory < ActiveRecord::Base
  has_permalink :title
  has_many :galleries
  belongs_to :template
  belongs_to :column
  belongs_to :page_layout, :class_name => "Column", :foreign_key => :main_column_id
  belongs_to :cover_gallery, :class_name => "Gallery", :foreign_key => :cover_gallery_id
  has_many :features, :as => :featurable, :dependent => :destroy
  has_many :images, :as => :viewable, :dependent => :destroy
  has_many :menus, :as => :navigatable, :dependent => :destroy
  named_scope :active, :conditions => { :active => true }
  default_scope :conditions => { :active => true }
  def to_param
    "#{self.id}-#{self.permalink}"
  end
end
