module Reservations
  class ProcessPayloadOne
    class << self
      def perform(params)
        reservation_attr = {
          adult_guest: params["adults"],
          children_guest: params["children"],
          infant_guest: params["infants"],
          nights: params["nights"],
          reservation_code: params["reservation_code"],
          reservation_origin: Reservation::reservation_origins['payload_1'],
          start_at: params["start_date"],
          end_at: params["end_date"],
          status: params["status"],
          payout_price_cents: convert_to_cents(params["payout_price"]),
          payout_price_currency: params["currency"],
          security_price_cents: convert_to_cents(params["security_price"]),
          security_price_currency: params["currency"],
          total_price_cents: convert_to_cents(params["total_price"]),
          total_price_currency: params["currency"],
          original_payload: params
        }

        guest_attr = {
          email: params["guest"]["email"],
          first_name: params["guest"]["first_name"],
          last_name: params["guest"]["last_name"],
          phone_numbers: params["guest"]["phone"]
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