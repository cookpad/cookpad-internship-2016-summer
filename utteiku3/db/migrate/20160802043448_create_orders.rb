class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.integer :status, null: false, default: 0
      t.datetime :ordered_at

      t.timestamps
    end
  end
end
