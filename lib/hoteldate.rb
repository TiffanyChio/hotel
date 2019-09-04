require_relative 'room'
require_relative 'reservation'

module Hotel
  class HotelDate
    
    attr_reader :id, :availability
    
    def initialize(id, rooms_list)
      @id = id  # This is a date object
      @availability = rooms_list.map{ |room| [room.id, :AVAILABLE] }.to_h  # This is a hash, input was array
    end
    
    # availability is a hash with key room_id and values
    # :AVAILABLE or reservation instance
    # Devin said that for end dates, reservation should not show up
    def add_reservation(reservation)
      @availability[reservation.room.id] = reservation
    end
    
  end
end
