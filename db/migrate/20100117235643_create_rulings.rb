class CreateRulings < ActiveRecord::Migration
  def self.up
    create_table :rulings do |t|
      t.references :inquest, :null => false
      t.string     :vote,    :null => false, :limit => 16
      t.timestamps
    end
    add_index :rulings, :inquest_id
    add_index :rulings, [:inquest_id, :vote]
  end

  def self.down
    remove_index :rulings, [:inquest_id, :vote]
    remove_index :rulings, :inquest_id
    drop_table :rulings
  end
end
