require 'date'
require_relative 'room'

module Hotel
  class Reservation
    
    attr_reader :id, :room, :start_date, :end_date, :cost
    
    def initialize(id:, room:, start_date:, end_date:, cost: nil)
      if end_date <= start_date
        raise ArgumentError, 'End date must be after start date.'
      end
      
      @id = id
      @room = room                # this is a room object
      @start_date = start_date    # this is already a date instance
      @end_date = end_date        # this is already a date instance
      @cost = cost
      @cost ||= room.cost.to_f
    end
    
    def find_total_cost
      return (@end_date - @start_date) * cost
    end
    
  end
end
