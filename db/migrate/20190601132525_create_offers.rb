class CreateOffers < ActiveRecord::Migration[5.2]
  def change
    create_table :offers do |t|
      t.string :origin
      t.string :destination
      t.time :take_off
      t.integer :user_id
      t.integer :maximum_intake
      t.integer :status

      t.timestamps
    end
  end
end
