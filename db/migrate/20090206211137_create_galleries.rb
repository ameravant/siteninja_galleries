class CreateGalleries < ActiveRecord::Migration
  def self.up
    create_table :galleries do |t|
      t.string :title, :description, :permalink
      t.integer :user_id
      t.integer :slideshow_delay_in_seconds, :default => 5
      t.integer :images_count, :features_count, :default => 0
      t.boolean :hidden, :slideshow, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :galleries
  end
end
