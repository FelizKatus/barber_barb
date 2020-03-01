class CreateCustomers < ActiveRecord::Migration[6.0]
  def change
    create_table :customers do |t|
      t.text :name
      t.text :phone
      t.text :barber
      t.text :dateandtime
      t.text :color

      t.timestamps
    end
  end
end
