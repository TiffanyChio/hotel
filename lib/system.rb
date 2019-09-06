require 'date'

require_relative 'room'
require_relative 'reservation'
require_relative 'hoteldate'
require_relative 'hotelblock'

module Hotel
  class System
    
    attr_reader :rooms, :reservations, :hoteldates, :hotelblocks
    
    def initialize
      @rooms = Hotel::Room.generate_rooms
      @reservations = []
      @hoteldates = []
      @hotelblocks = {}
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
      
      #TIFF GET RID OF THIS AND CORRESPONDING TEST
      # return new_reservation
      return new_reservation
    end
    
    def find_all_available_rooms(start_date, end_date)
      current_date = start_date.dup
      all_occupied_rooms = []
      
      until current_date == end_date
        hotel_date = find_date(current_date)
        
        all_occupied_rooms += hotel_date.rooms_occupied if hotel_date 
        
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
    
    # Dates are strings
    # hb_rooms is an array of room_ids
    # Discount rate can be whatever number
    def create_hotelblock(start_date:, end_date:, hb_rooms:, discount_rate:)
      start_date = Date.parse(start_date)
      end_date = Date.parse(end_date)
      discount_rate = discount_rate.to_f
      hb_rooms.map! { |room_id| find_room(room_id) }
      
      if hb_rooms.length > 5
        raise ArgumentError, 'A block can contain a maximum of 5 rooms.'
      end
      
      available_rooms = find_all_available_rooms(start_date, end_date)
      
      # Does block contain a room that is not part of available rooms?
      # If so raise an error.
      # Hey TIFF make this part longer to include which room
      if hb_rooms.map{ |room| available_rooms.include? room}.include? false
        raise ArgumentError, 'Block contains room already booked.'
      end
      
      hb_id = @hotelblocks.length + 1
      @hotelblocks[hb_id] = []
      
      
      hb_rooms.each do |room|
        new_hotel_block = Hotel::HotelBlock.new(id: hb_id, room: room, start_date: start_date, end_date: end_date, cost:discount_rate)
        
        @hotelblocks[hb_id] << new_hotel_block
        
        add_to_dates(start_date, end_date, new_hotel_block)
      end
    end
    
    def reserve_from_block(block_id, room_id)
      # change status 
      # make reservation with pre-determined arg
      # add res to @reservations
    end
    
  end
end



