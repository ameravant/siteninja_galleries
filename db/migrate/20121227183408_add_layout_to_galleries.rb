class AddLayoutToGalleries < ActiveRecord::Migration
  def self.up
    add_column :galleries, :main_column_id, :integer
  end

  def self.down
    remove_column :galleries, :main_column_id
  end
end