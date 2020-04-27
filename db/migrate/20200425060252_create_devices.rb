class CreateDevices < ActiveRecord::Migration[6.0]
  def change
    create_table :devices do |t|
      t.string :model
      t.string :vendor

      t.timestamps
    end
  end
end
