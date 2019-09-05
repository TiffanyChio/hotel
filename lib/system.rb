require 'date'

require_relative 'room'
require_relative 'reservation'
require_relative 'hoteldate'
require_relative 'hotelblock'

module Hotel
  class System
    
    attr_reader :rooms, :reservations, :hoteldates
    
    NUM_ROOMS = 20
    COST_PER_NIGHT = 200
    
    def initialize
      @rooms = generate_rooms
      @reservations = []
      @hoteldates = []
    end
    
    def generate_rooms
      array_of_room_obj = []
      
      (1..NUM_ROOMS).each do |i|
        array_of_room_obj << Hotel::Room.new(i, COST_PER_NIGHT.to_f)
      end
      
      return array_of_room_obj
    end
    
    # Assume date inputs come in string format
    def make_reservation(start_date:, end_date:) 
      id = @reservations.length + 1
      start_date = Date.parse(start_date)
      end_date = Date.parse(end_date)
      
      # Find a room with no overlap
      room = find_all_available_rooms(start_date, end_date)[0]
      raise ArgumentError, 'No rooms available' if room == nil
      
      # Create Reservation
      new_reservation = Hotel::Reservation.new(id: id, room: room, start_date: start_date, end_date: end_date)
      
      # Connect to Reservations List
      @reservations << new_reservation
      
      # Create Date or Add to it, add to Dates list
      add_to_dates(start_date, end_date, new_reservation)
      
      # return new_reservation
      return new_reservation
    end
    
    def find_all_available_rooms(start_date, end_date)
      current_date = start_date.dup
      all_occupied_rooms = []
      
      until current_date == end_date
        hotel_date = find_date(current_date)
        
        if hotel_date 
          all_occupied_rooms += hotel_date.rooms_occupied
        end
        
        current_date += 1
      end
      
      all_occupied_rooms.uniq!
      
      return @rooms - all_occupied_rooms
    end
    
    def add_to_dates(start_date, end_date, new_reservation)
      current_date = start_date.dup
      
      until current_date == end_date
        date_obj = find_date(current_date)
        
        if date_obj 
          date_obj.add_reservation(new_reservation)
        else
          @hoteldates << Hotel::HotelDate.new(current_date)
          find_date(current_date).add_reservation(new_reservation)
        end
        
        current_date += 1
      end
    end
    
    def find_room(room_id)
      return @rooms.find { |room| room.id == room_id }
    end
    
    def find_date(date_obj)
      return @hoteldates.find { |hotel_date| hotel_date.id == date_obj }
    end
    
    def list_reservations_for(date_string)
      hotel_date = find_date(Date.parse(date_string))
      if hotel_date 
        return hotel_date.list_reservations
      else 
        return nil
      end
    end
    
  end
end

