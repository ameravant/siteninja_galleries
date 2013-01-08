class AddMainColumnIdToGalleries < ActiveRecord::Migration
  def self.up
    add_column :gallery_categories, :main_column_id, :integer
  end

  def self.down
    remove_column :gallery_categories, :main_column_id
  end
end