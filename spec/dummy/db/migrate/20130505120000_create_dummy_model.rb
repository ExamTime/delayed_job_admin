class CreateDummyModel < ActiveRecord::Migration
  def self.up
    create_table :dummy_models do |table|
      table.string  :name
    end
  end

  def self.down
    drop_table :dummy_models
  end
end
