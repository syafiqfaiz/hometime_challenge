class ReservationsController < ApplicationController
  def index
    @reservations = Reservation.paginate(page: params[:page])
  end

  def show
    @reservation = Reservation.find(params[:id])
  end

  def create
    @reservation = Reservations::Process.perform(params)

    head :created
  end

end
