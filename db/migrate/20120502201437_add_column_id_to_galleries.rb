class AddColumnIdToGalleries < ActiveRecord::Migration
  def self.up
    add_column :galleries, :column_id, :integer
  end

  def self.down
    remove_column :galleries, :column_id
  end
end