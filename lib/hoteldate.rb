require_relative 'room'
require_relative 'reservation'

module Hotel
  class HotelDate
    
    attr_reader :id, :occupied
    
    def initialize(id)
      # id is a date object
      @id = id  
      # occupied is a hash with key room_id and values of reservation instance
      @occupied = {}  
    end
    
    # Adds either reservation or hotel blocks to @occupied hash.
    # Below the parameter is called "reservation" but
    # logic also works for hotel blocks.
    def add_occupancy(reservation)
      @occupied[reservation.room] = reservation
    end
    
    # Returns only reservations and not hotel blocks as per specs.
    def list_reservations
      return @occupied.values.select { |value| value.class == Hotel::Reservation }
    end
    
    # Returns all occupied rooms, either reserved or blocked.
    def rooms_occupied
      return @occupied.keys
    end
    
  end
end
