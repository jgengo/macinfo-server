class CreateOs < ActiveRecord::Migration[6.0]
  def change
    create_table :os do |t|
      t.string :version
      t.string :build

      t.timestamps
    end
  end
end
