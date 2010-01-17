class CreateInquests < ActiveRecord::Migration
  
  def self.up
    create_table :inquests do |t|
      t.string :image_url, :null => false, :limit => 255
      t.timestamps
    end
  end

  def self.down
    drop_table :inquests
  end
  
end
