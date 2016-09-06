class CreateCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :categories do |t|
      t.string :name,       null: false
      t.string :image_url,  null: false

      t.timestamps
    end
  end
end
