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
      
      # keys will be hotel block ids (shared by all rooms within block)
      # values will be arrays of hotel block objects within same block
      @hotelblocks = {}
    end
    
    def find_room(room_id)
      return @rooms.find { |room| room.id == room_id }
    end
    
    def find_date(date_obj)
      return @hoteldates.find { |hotel_date| hotel_date.id == date_obj }
    end
    
    def find_all_available_rooms(start_date, end_date)
      current_date = start_date.dup
      available_rooms = @rooms.dup
      
      until current_date == end_date
        hotel_date = find_date(current_date)
        available_rooms -= hotel_date.rooms_occupied if hotel_date
        current_date += 1
      end
      
      return available_rooms
    end
    
    def make_reservation(start_date, end_date) 
      id = @reservations.length + 1
      
      # assign the first available room to the reservation
      room = find_all_available_rooms(start_date, end_date)[0]
      raise FullOccupancyError.new('No rooms available for the date range.') if room == nil
      
      new_reservation = Hotel::Reservation.new(id: id, room: room, start_date: start_date, end_date: end_date)
      
      @reservations << new_reservation
      add_to_dates(start_date, end_date, new_reservation)
      
      return new_reservation
    end
    
    # new_occupancy refers to reservation or hotel block to be added to dates
    def add_to_dates(start_date, end_date, new_occupancy)
      current_date = start_date.dup
      
      until current_date == end_date
        date_obj = find_date(current_date)
        
        if date_obj 
          date_obj.add_occupancy(new_occupancy)
        else
          new_date_obj = Hotel::HotelDate.new(current_date)
          @hoteldates << new_date_obj
          new_date_obj.add_occupancy(new_occupancy)
        end
        
        current_date += 1
      end
    end
    
    # TIFF CHANGED FROM STRING TO OBJ
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
    
    def find_open_rooms_from_block(hb_id)
      hotel_blocks = @hotelblocks[hb_id]
      open_rooms = hotel_blocks.select { |hotel_block| hotel_block.status == :AVAILABLE}
      
      open_rooms.map! { |hotel_block| hotel_block.room.id}
      
      return open_rooms
    end
    
    def reserve_from_block(hb_id, room_id)
      # check availability
      unless find_open_rooms_from_block(hb_id).include? room_id
        raise ArgumentError, 'The room you are trying to book is not available.'
      end
      
      # change status 
      hotel_block = @hotelblocks[hb_id].find {|hb| hb.room.id == room_id}
      hotel_block.change_status
      
      # make reservation with pre-determined arg
      id = @reservations.length + 1
      room = find_room(room_id)
      start_date = hotel_block.start_date
      end_date = hotel_block.end_date
      cost = hotel_block.cost
      
      new_reservation = Hotel::Reservation.new(id: id, room: room, start_date: start_date, end_date: end_date, cost: cost)
      
      # Connect to Reservations List
      @reservations << new_reservation 
    end
    
  end
end

class FullOccupancyError < StandardError
end

