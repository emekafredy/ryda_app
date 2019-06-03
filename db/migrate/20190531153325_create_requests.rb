class CreateRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :requests do |t|
      t.string :origin
      t.string :destination
      t.datetime :take_off
      t.integer :user_id
      t.integer :status
      t.integer :offer_id

      t.timestamps
    end
  end
end
