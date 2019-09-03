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
      @date_range = create_date_array  # this does not include the end date, so all occupied nights
      @total_cost = (@end_date - @start_date) * @room.cost
    end
    
    # Returns array of date objects for all dates 
    # start_date to end_date
    # end_date not inclusive
    def create_date_array
      days = []
      current_date = @start_date.dup
      
      # TIFF: you can change it to > if you need to include end date
      until current_date == @end_date
        days << current_date
        current_date += 1
      end
      
      return days
    end
    
  end
end
