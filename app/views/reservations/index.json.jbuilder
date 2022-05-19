json.reservations do
	json.array! @reservations do |reservation|
    json.id reservation.id
    json.adult_guest reservation.adult_guest
    json.children_guest reservation.children_guest
    json.end_at reservation.end_at
    json.infant_guest reservation.infant_guest
    json.nights reservation.nights
    json.payout_price_cents reservation.payout_price_cents
    json.payout_price_currency reservation.payout_price_currency
    json.reservation_code reservation.reservation_code
    json.reservation_origin reservation.reservation_origin
    json.security_price_cents reservation.security_price_cents
    json.security_price_currency reservation.security_price_currency
    json.start_at reservation.start_at
    json.status reservation.status
    json.total_price_cents reservation.total_price_cents
    json.total_price_currency reservation.total_price_currency
    json.created_at reservation.created_at
    json.updated_at reservation.updated_at
    json.guest do
      json.id reservation.guest.id
      json.additional_phone_numbers reservation.guest.additional_phone_numbers
      json.email reservation.guest.email
      json.first_name reservation.guest.first_name
      json.last_name reservation.guest.last_name
      json.phone_numbers reservation.guest.phone_numbers
      json.created_at reservation.guest.created_at
      json.updated_at reservation.guest.updated_at
    end
  end
end