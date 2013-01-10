class AddCoverGalleryIdToGalleryCategories < ActiveRecord::Migration
  def self.up
    add_column :gallery_categories, :cover_gallery_id, :integer
  end

  def self.down
    remove_column :gallery_categories, :cover_gallery_id
  end
end