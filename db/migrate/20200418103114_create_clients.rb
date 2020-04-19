class CreateClients < ActiveRecord::Migration[6.0]
  def change
    create_table :clients do |t|
      t.references  :os, null: true

      t.string      :token
      t.string      :hostname
      t.string      :active_user
      t.string      :uuid
      t.integer     :uptime
      
      t.timestamps
    end
  end
end
