require 'date'
require_relative 'room'

module Hotel
  class Reservation
    
    attr_reader :id, :room, :start_date, :end_date, :cost
    
    def initialize(id:, room:, start_date:, end_date:, cost: room.cost)
      if end_date <= start_date
        raise ArgumentError, 'End date must be after start date.'
      end
      
      @id = id
      @room = room                # this is a room object
      @start_date = start_date    # this is a date instance
      @end_date = end_date        # this is a date instance
      @cost = cost
    end
    
    def find_total_cost
      return (@end_date - @start_date) * @cost.to_f
    end
    
  end
end
