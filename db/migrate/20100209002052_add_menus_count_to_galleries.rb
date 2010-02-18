class AddMenusCountToGalleries < ActiveRecord::Migration
  def self.up
    add_column :galleries, :menus_count, :integer, :default => 0
    add_column :galleries, :position, :integer, :default => 1
  end

  def self.down
    remove_column :galleries, :menus_count
    remove_column :galelries, :position
  end
end
