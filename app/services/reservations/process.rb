module Reservations
  class Process
    class << self
      def perform(params)
        if is_payload_1(params)
          guest_attr, reservation_attr = Reservations::ProcessPayloadOne.perform(params)
        elsif is_payload_2(params)
          guest_attr, reservation_attr = Reservations::ProcessPayloadTwo.perform(params)
        else
          raise 'Unprocessable entity'
        end

        @guest = Guest.find_by_email(guest_attr[:email])

        if @guest
          @guest.update(guest_attr)
        else
          @guest = Guest.create(guest_attr)
        end

        @reservation = @guest.reservations
          .find_by_reservation_code(reservation_attr[:reservation_code])
        if @reservation
          @reservation.update(reservation_attr)
        else
          @reservation = @guest.reservations.create(reservation_attr)
        end

        @guest
      end

      private
      def is_payload_1(params)
        params['reservation_code']
      end

      def is_payload_2(params)
        params['reservation']['code']
      end
    end
  end
end