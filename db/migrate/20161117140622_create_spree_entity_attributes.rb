class CreateSpreeEntityAttributes < ActiveRecord::Migration

  def change
    create_table :spree_entity_attributes do |t|
      t.string :entity, :null => false, :limit => 100
  	  t.column :entity_id, :bigint, :null => false
  	  t.string :key, :null => false, :limit => 255
  	  t.string :value, :default => nil, :null => true, :limit => 1024
      t.timestamps null: false
    end

    add_index :spree_entity_attributes, [:key, :entity]
    add_index :spree_entity_attributes, [:entity_id]
  end
end
