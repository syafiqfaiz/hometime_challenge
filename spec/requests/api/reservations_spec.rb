require 'swagger_helper'

RSpec.describe 'api/reservations', type: :request do
  path '/reservations' do
    ######################################################################
    # can be refactored, but I dont have enough time                     #
    # there is a known bug where database is not cleaned after each test #
    ######################################################################
    post 'Creates a reservation for payload 1' do
      tags 'reservation 1'
      consumes 'application/json'
      parameter name: :reservation, in: :body, schema: {
        type: :object,
        properties: {
          reservation_code:  { type: :string },
          start_date:  { type: :string },
          end_date:  { type: :string },
          nights:  { type: :integer },
          guests: { type: :integer },
          adults: { type: :integer },
          children: { type: :integer },
          infants: { type: :integer },
          status:  { type: :string },
          guest: {
            type: :object,
            first_name:  { type: :string },
            last_name:  { type: :string },
            phone: { type: :string },
            email:  { type: :string },
          },
          currency:  { type: :string },
          payout_price:  { type: :string },
          security_price:  { type: :string },
          total_price:  { type: :string },
        }
      }

      response '201', 'reservation create' do
        let(:reservation) { 
          {
            "reservation_code": "YYY12345678",
            "start_date": "2021-04-14",
            "end_date": "2021-04-18",
            "nights": 4,
            "guests": 4,
            "adults": 2,
            "children": 2,
            "infants": 0,
            "status": "accepted",
            "guest": {
            "first_name": "Wayne",
            "last_name": "Woodbridge",
            "phone": "639123456789",
            "email": "wayne_woodbridge@bnb.com"
            },
            "currency": "AUD",
            "payout_price": "4200.00",
            "security_price": "500",
            "total_price": "4700.00"
          }
         }
        run_test! do
          expect(Reservation.count).to eq 1
          expect(Reservation.first.guest.email).to eq "wayne_woodbridge@bnb.com"
        end
      end

      response '201', 'reservation updated' do
        guest_attr, reservation_attr = Reservations::ProcessPayloadOne.perform({
          "reservation_code": "YYY12345678",
          "start_date": "2021-04-14",
          "end_date": "2021-04-18",
          "nights": 4,
          "guests": 4,
          "adults": 2,
          "children": 2,
          "infants": 0,
          "status": "confirmed",
          "guest": {
            "first_name": "Wayne",
            "last_name": "Woodbridge",
            "phone": "639123456789",
            "email": "wayne_woodbridge@bnb.com"
          }.with_indifferent_access,
          "currency": "AUD",
          "payout_price": "4200.00",
          "security_price": "500",
          "total_price": "4700.00"
        }.with_indifferent_access)
        guest = Guest.create(guest_attr)

        guest.reservations.create(reservation_attr)
        let(:reservation) { 
          {
            "reservation_code": "YYY12345678",
            "start_date": "2021-04-14",
            "end_date": "2021-04-19",
            "nights": 5,
            "guests": 4,
            "adults": 2,
            "children": 2,
            "infants": 0,
            "status": "confirmed",
            "guest": {
            "first_name": "Wayne",
            "last_name": "Woodbridge",
            "phone": "639123456789",
            "email": "wayne_woodbridge@bnb.com"
            },
            "currency": "AUD",
            "payout_price": "4200.00",
            "security_price": "500",
            "total_price": "4700.00"
          }
         }
        run_test! do
          expect(Reservation.count).to eq 1
          expect(Reservation.exists?(reservation_code:  "YYY12345678")).to eq true
          expect(Reservation.first.guest.email).to eq "wayne_woodbridge@bnb.com"
          expect(Reservation.first.nights).to eq 5
          expect(Reservation.first.status).to eq "confirmed"
        end
      end

      response '201', 'new reservation with same guest' do
        guest_attr, reservation_attr = Reservations::ProcessPayloadOne.perform({
          "reservation_code": "YYY12345678",
          "start_date": "2021-04-14",
          "end_date": "2021-04-19",
          "nights": 5,
          "guests": 4,
          "adults": 2,
          "children": 2,
          "infants": 0,
          "status": "confirmed",
          "guest": {
            "first_name": "Wayne",
            "last_name": "Woodbridge",
            "phone": "639123456789",
            "email": "wayne_woodbridge@bnb.com"
          }.with_indifferent_access,
          "currency": "AUD",
          "payout_price": "4200.00",
          "security_price": "500",
          "total_price": "4700.00"
        }.with_indifferent_access)
        guest = Guest.find_by_email("wayne_woodbridge@bnb.com")

        guest.reservations.create(reservation_attr)
        let(:reservation) { 
          {
            "reservation_code": "ZZZ12345678",
            "start_date": "2021-04-14",
            "end_date": "2021-04-19",
            "nights": 5,
            "guests": 4,
            "adults": 2,
            "children": 2,
            "infants": 0,
            "status": "confirmed",
            "guest": {
            "first_name": "Wayne",
            "last_name": "Woodbridge",
            "phone": "639123456789",
            "email": "wayne_woodbridge@bnb.com"
            },
            "currency": "AUD",
            "payout_price": "4200.00",
            "security_price": "500",
            "total_price": "4700.00"
          }
         }
        run_test! do
          expect(Reservation.count).to eq 2
          expect(Reservation.exists?(reservation_code:  "ZZZ12345678")).to eq true
          expect(Guest.count).to eq 1
        end
      end
    end

    ####################################################################################
    # due to database cleaner issue, I couldnt complete the test suite for 2nd payload #
    ####################################################################################

    # post 'Creates a reservation for payload 2' do
    #   tags 'reservation 2'
    #   consumes 'application/json'
    #   parameter name: :reservation, in: :body, schema: {
    #     type: :object,
    #     properties: {
    #       reservation: {
    #         type: :object,
    #         code:  { type: :string },
    #         start_date:  { type: :string },
    #         end_date: { type: :string },
    #         expected_payout_amount: { type: :string },
    #         guest_details: {
    #           type: :object,
    #           localized_description: { type: :string },
    #           number_of_adults: { type: :integer },
    #           number_of_children: { type: :integer },
    #           number_of_infants: { type: :integer },
    #         },
    #         guest_email: { type: :string },
    #         guest_first_name: { type: :string },
    #         guest_last_name:{ type: :string },
    #         guest_phone_numbers: { type: :array },
    #         listing_security_price_accurate:{ type: :string },
    #         host_currency:{ type: :string },
    #         nights: { type: :integer },
    #         number_of_guests: { type: :integer },
    #         status_type: { type: :string },
    #         total_paid_amount_accurate: { type: :string }
    #       }
    #     }
    #   }

    #   response '201', 'reservation created' do
    #     let(:reservation) {
    #       {
    #         "reservation": {
    #           "code": "XXX12345679",
    #           "start_date": "2021-03-12",
    #           "end_date": "2021-03-16",
    #           "expected_payout_amount": "3800.00",
    #           "guest_details": {
    #             "localized_description": "4 guests",
    #             "number_of_adults": 2,
    #             "number_of_children": 2,
    #             "number_of_infants": 0
    #           },
    #           "guest_email": "wayne_woodbridge@bnb.com",
    #           "guest_first_name": "Wayne",
    #           "guest_last_name": "Woodbridge",
    #           "guest_phone_numbers": [
    #             "639123456789",
    #             "639123456789"
    #           ],
    #           "listing_security_price_accurate": "500.00",
    #           "host_currency": "AUD",
    #           "nights": 4,
    #           "number_of_guests": 4,
    #           "status_type": "accepted",
    #           "total_paid_amount_accurate": "4300.00"
    #         }
    #       }
    #     }
        
    #     run_test! do
    #       expect(Reservation.count).to eq 1
    #       expect(Reservation.first.guest.email).to eq "wayne_woodbridge@bnb.com"
    #     end
    #   end

    #   response '201', 'reservation updated' do
    #     guest_attr, reservation_attr = Reservations::ProcessPayloadTwo.perform({
    #       "reservation": {
    #         "code": "XXX12345679",
    #         "start_date": "2021-03-12",
    #         "end_date": "2021-03-16",
    #         "expected_payout_amount": "3800.00",
    #         "guest_details": {
    #           "localized_description": "4 guests",
    #           "number_of_adults": 2,
    #           "number_of_children": 2,
    #           "number_of_infants": 0
    #         }.with_indifferent_access,
    #         "guest_email": "wayne_woodbridge@bnb.com",
    #         "guest_first_name": "Wayne",
    #         "guest_last_name": "Woodbridge",
    #         "guest_phone_numbers": [
    #           "639123456789",
    #           "639123456789"
    #         ],
    #         "listing_security_price_accurate": "500.00",
    #         "host_currency": "AUD",
    #         "nights": 4,
    #         "number_of_guests": 4,
    #         "status_type": "accepted",
    #         "total_paid_amount_accurate": "4300.00"
    #       }.with_indifferent_access
    #     }.with_indifferent_access)
    #     guest = Guest.find_by_email("wayne_woodbridge@bnb.com")

    #     guest.reservations.create(reservation_attr)
    #     let(:reservation) {
    #       {
    #         "reservation": {
    #           "code": "XXX12345679",
    #           "start_date": "2021-03-12",
    #           "end_date": "2021-03-17",
    #           "expected_payout_amount": "3800.00",
    #           "guest_details": {
    #             "localized_description": "4 guests",
    #             "number_of_adults": 2,
    #             "number_of_children": 2,
    #             "number_of_infants": 0
    #           },
    #           "guest_email": "wayne_woodbridge@bnb.com",
    #           "guest_first_name": "Wayne",
    #           "guest_last_name": "Woodbridge",
    #           "guest_phone_numbers": [
    #             "639123456789",
    #             "639123456789"
    #           ],
    #           "listing_security_price_accurate": "500.00",
    #           "host_currency": "AUD",
    #           "nights": 5,
    #           "number_of_guests": 4,
    #           "status_type": "confirmed",
    #           "total_paid_amount_accurate": "4300.00"
    #         }
    #       }
    #     }
    #     run_test! do
    #       expect(Reservation.count).to eq 1
    #       expect(Reservation.exists?(reservation_code:  "XXX12345678")).to eq true
    #       expect(Reservation.first.guest.email).to eq "wayne_woodbridge@bnb.com"
    #       expect(Reservation.first.nights).to eq 5
    #       expect(Reservation.first.status).to eq "confirmed"
    #     end
    #   end

    #   response '201', 'new reservation with same guest' do
    #     guest_attr, reservation_attr = Reservations::ProcessPayloadOne.perform({
    #       "reservation_code": "YYY12345678",
    #       "start_date": "2021-04-14",
    #       "end_date": "2021-04-19",
    #       "nights": 5,
    #       "guests": 4,
    #       "adults": 2,
    #       "children": 2,
    #       "infants": 0,
    #       "status": "confirmed",
    #       "guest": {
    #         "first_name": "Wayne",
    #         "last_name": "Woodbridge",
    #         "phone": "639123456789",
    #         "email": "wayne_woodbridge@bnb.com"
    #       }.with_indifferent_access,
    #       "currency": "AUD",
    #       "payout_price": "4200.00",
    #       "security_price": "500",
    #       "total_price": "4700.00"
    #     }.with_indifferent_access)
    #     guest = Guest.find_by_email("wayne_woodbridge@bnb.com")

    #     guest.reservations.create(reservation_attr)
    #     let(:reservation) {
    #       {
    #         "reservation": {
    #           "code": "XXX12345679",
    #           "start_date": "2021-03-12",
    #           "end_date": "2021-03-17",
    #           "expected_payout_amount": "3800.00",
    #           "guest_details": {
    #             "localized_description": "4 guests",
    #             "number_of_adults": 2,
    #             "number_of_children": 2,
    #             "number_of_infants": 0
    #           },
    #           "guest_email": "wayne_woodbridge@bnb.com",
    #           "guest_first_name": "Wayne",
    #           "guest_last_name": "Woodbridge",
    #           "guest_phone_numbers": [
    #             "639123456789",
    #             "639123456789"
    #           ],
    #           "listing_security_price_accurate": "500.00",
    #           "host_currency": "AUD",
    #           "nights": 5,
    #           "number_of_guests": 4,
    #           "status_type": "confirmed",
    #           "total_paid_amount_accurate": "4300.00"
    #         }
    #       }
    #     }
    #     run_test! do
    #       expect(Reservation.count).to eq 2
    #       expect(Reservation.exists?(reservation_code:  "XXX12345679")).to eq true
    #       expect(Guest.count).to eq 1
    #     end
    #   end
    # end

  end
end
