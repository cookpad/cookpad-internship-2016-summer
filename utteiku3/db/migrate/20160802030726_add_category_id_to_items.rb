class AddCategoryIdToItems < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :category_id, :integer, null: true

    add_index  :items, :category_id
  end
end
