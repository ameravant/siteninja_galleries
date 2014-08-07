class Gallery < ActiveRecord::Base
  unloadable
  has_permalink :title
  has_many :images, :as => :viewable, :dependent => :destroy
  accepts_nested_attributes_for :images, :allow_destroy => true
  attr_accessible :title, :description, :attached_assets_attributes
  has_many :features, :as => :featurable, :dependent => :destroy
  has_many :menus, :as => :navigatable, :dependent => :destroy
  belongs_to :gallery_category
  belongs_to :column
  belongs_to :page_layout, :class_name => "Column", :foreign_key => :main_column_id
  belongs_to :user, :counter_cache => true
  validates_presence_of :user_id, :title
  validates_presence_of :slideshow_delay_in_seconds, :if => :is_slideshow?, :message => "must be entered if slideshow is enabled"
  validates_numericality_of :slideshow_delay_in_seconds, :allow_blank => true
  named_scope :public, :conditions => ["hidden = ? and images_count > ?", false, 0], :order => "position"
  default_scope :order => "position"
  accepts_nested_attributes_for :images
  
  def name # for model consistency, name is treated as title
    self.title
  end
  
  def is_slideshow?
    self.slideshow?
  end
    
  def to_param
    "#{self.id}-#{self.permalink}"
  end
  
  def blurb
    self.description
  end
end
