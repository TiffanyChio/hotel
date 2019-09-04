require 'date'
require_relative 'room'

module Hotel
  class Reservation
    
    attr_reader :id, :room, :start_date, :end_date, :date_range, :total_cost
    
    def initialize(id:, room:, start_date:, end_date:)
      if end_date <= start_date
        raise ArgumentError, 'End date must be after start date.'
      end
      
      @id = id
      @room = room                # this is a room object
      @start_date = start_date    # this is already a date instance
      @end_date = end_date        # this is already a date instance
      @total_cost = (@end_date - @start_date) * @room.cost
    end
    
  end
end
