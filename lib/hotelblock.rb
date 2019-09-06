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
  end
end

