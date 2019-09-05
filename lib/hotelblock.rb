require 'date'
require_relative 'reservation'

module Hotel
  class HotelBlock < Reservation
    
    # id here is the id of the hotel block
    # shared by all rooms within same block
    def initialize(id:, room:, start_date:, end_date:, cost: )
      super
    end
    
  end
end
