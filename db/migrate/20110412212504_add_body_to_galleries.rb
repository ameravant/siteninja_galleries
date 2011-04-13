class AddBodyToGalleries < ActiveRecord::Migration
  def self.up
    add_column :galleries, :body, :text
  end

  def self.down
    remove_column :galleries, :body
  end
end
