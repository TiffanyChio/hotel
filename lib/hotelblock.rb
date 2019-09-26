require 'date'
require_relative 'reservation'

module Hotel
  class HotelBlock < Reservation
    
    attr_reader :status
    
    # id here is the id of the hotel block
    # shared by all rooms within same block
    def initialize(id:, room:, start_date:, end_date:, cost:)
      super
      @status = :AVAILABLE
    end
    
    def change_status
      @status = :UNAVAILABLE
    end
    
    def make_res_from_hb(reservation_id)
      new_reservation = Hotel::Reservation.new(id: reservation_id, room: @room, start_date: @start_date, end_date: @end_date, cost: @cost)
      return new_reservation
    end
  end
end

