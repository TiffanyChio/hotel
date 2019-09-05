require_relative 'room'
require_relative 'reservation'

module Hotel
  class HotelDate
    
    attr_reader :id, :occupied
    
    def initialize(id)
      @id = id  # This is a date object
      @occupied = {}  
    end
    
    # occupied is a hash with key room_id and values of reservation instance
    # Devin said that for end dates, reservation should not show up
    def add_reservation(reservation)
      @occupied[reservation.room] = reservation
    end
    
    # returns array of reservation objects
    def list_reservations
      return @occupied.values
    end
    
    def rooms_occupied
      return @occupied.keys
    end
  end
end
