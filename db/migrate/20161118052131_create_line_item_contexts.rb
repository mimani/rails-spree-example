class CreateLineItemContexts < ActiveRecord::Migration

  def change
    create_table :spree_line_item_contexts do |t|
    	t.column :line_item_id, :int, :null => false
    	t.string :serial_number, :limit => 255 
    	t.timestamps null: false
    	#TODO: More attributes has to be add as migrations
    end

    add_index :spree_line_item_contexts, [:line_item_id]
  end

end
