class CreateReservations < ActiveRecord::Migration[6.1]
  def change
    create_table :reservations do |t|
      t.string :reservation_code
      t.integer :reservation_origin
      t.datetime :start_at
      t.datetime :end_at
      t.string :status
      t.integer :adult_guest, default: 0
      t.integer :children_guest, default: 0
      t.integer :infant_guest, default: 0
      t.integer :nights, default: 0
      t.json :original_payload
      t.monetize :total_price
      t.monetize :payout_price
      t.monetize :security_price
      t.integer :guest_id

      t.timestamps
    end
    add_index :reservations, :reservation_code
  end
end
