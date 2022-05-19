# == Schema Information
#
# Table name: reservations
#
#  id                      :bigint           not null, primary key
#  adult_guest             :integer          default(0)
#  children_guest          :integer          default(0)
#  end_at                  :datetime
#  infant_guest            :integer          default(0)
#  nights                  :integer          default(0)
#  original_payload        :json
#  payout_price_cents      :integer          default(0), not null
#  payout_price_currency   :string           default("USD"), not null
#  reservation_code        :string
#  reservation_origin      :integer
#  security_price_cents    :integer          default(0), not null
#  security_price_currency :string           default("USD"), not null
#  start_at                :datetime
#  status                  :string
#  total_price_cents       :integer          default(0), not null
#  total_price_currency    :string           default("USD"), not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  guest_id                :integer
#
# Indexes
#
#  index_reservations_on_reservation_code  (reservation_code)
#
class Reservation < ApplicationRecord
  belongs_to :guest

  validates :reservation_code, uniqueness: true

  enum reservation_origin: {
    payload_1: 0,
    payload_2: 1
  }
end
