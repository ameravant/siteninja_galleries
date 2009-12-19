class Gallery < ActiveRecord::Base
  has_permalink :title
  has_many :images, :as => :viewable, :dependent => :destroy
  has_many :features, :as => :featurable, :dependent => :destroy
  belongs_to :user, :counter_cache => true
  validates_presence_of :user_id, :title
  validates_presence_of :slideshow_delay_in_seconds, :if => :is_slideshow?, :message => "must be entered if slideshow is enabled"
  validates_numericality_of :slideshow_delay_in_seconds, :allow_blank => true
  named_scope :public, :conditions => ["hidden = ? and images_count > ?", false, 0], :order => "title"
  
  def name # for model consistency, name is treated as title
    self.title
  end
  
  def is_slideshow?
    self.slideshow?
  end
    
  def to_param
    "#{self.id}-#{self.permalink}"
  end
end
