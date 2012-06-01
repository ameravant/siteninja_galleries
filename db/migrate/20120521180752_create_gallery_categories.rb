class CreateGalleryCategories < ActiveRecord::Migration
  def self.up
    add_column :galleries, :sort_order, :integer, :default => 1
    add_column :galleries, :gallery_category_id, :integer
    create_table :gallery_categories do |t|
      t.string  "title"
      t.string  "permalink"
      t.text    "description"
      t.integer "menus_count",    :default => 0
      t.integer "images_count",   :default => 0
      t.integer "features_count", :default => 0
      t.boolean "active",         :default => true
      t.integer "sort_order"
      t.integer "account_id",     :default => 1
      t.boolean "master",         :default => false
      t.integer "legacy_id"
      t.integer "column_id"
      t.integer "template_id"
      t.timestamps
    end
    add_index :gallery_categories, :account_id
  end

  def self.down
    remove_column :galleries, :position
    remove_column :galleries, :gallery_category_id
    drop_table :gallery_categories
  end
end