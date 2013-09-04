class CreateDummyModel < ActiveRecord::Migration
  def self.up
    create_table :dummy_models do |table|
      table.string  :name
      table.integer  :delay_in_seconds
    end
  end

  def self.down
    drop_table :dummy_models
  end
end
