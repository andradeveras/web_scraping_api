class CreateCars < ActiveRecord::Migration[7.1]
  def change
    create_table :cars do |t|
      t.string :brand
      t.string :model
      t.string :price

      t.timestamps
    end
  end
end
