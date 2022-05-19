module Reservations
  class ProcessPayloadTwo
    class << self
      def perform(params)
        reservation = params["reservation"]
        reservation_attr = {
          adult_guest: reservation["guest_details"]["number_of_adults"],
          children_guest: reservation["guest_details"]["number_of_children"],
          infant_guest: reservation["guest_details"]["number_of_infants"],
          nights: reservation["nights"],
          reservation_code: reservation["code"],
          reservation_origin: Reservation::reservation_origins['payload_1'],
          start_at: reservation["start_date"],
          end_at: reservation["end_date"],
          status: params["status_type"],
          payout_price_cents: convert_to_cents(reservation["expected_payout_amount"]),
          payout_price_currency: reservation["host_currency"],
          security_price_cents: convert_to_cents(reservation["listing_security_price_accurate"]),
          security_price_currency: reservation["host_currency"],
          total_price_cents: convert_to_cents(reservation["total_paid_amount_accurate"]),
          total_price_currency: reservation["host_currency"],
          original_payload: params
        }

        guest_attr = {
          email: reservation["guest_email"],
          first_name: reservation["guest_first_name"],
          last_name: reservation["guest_last_name"],
          phone_numbers: reservation["guest_phone_numbers"][0],
          additional_phone_numbers: reservation["guest_phone_numbers"]
        }

        return guest_attr, reservation_attr
      end

      private
      def convert_to_cents(price)
        price ? price.to_i * 100 : 0
      end
    end
  end
end