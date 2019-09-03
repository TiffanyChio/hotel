require 'date'
require_relative 'room'

module Hotel
  class Reservation
    
    attr_reader :id, :room, :start_date, :end_date, :dates, :total_cost
    
    def initialize(id:, room:, start_date:, end_date:, total_cost:nil)
      @id = id
      @room = room                # this is a room object
      @start_date = start_date    # this is already a date instance
      @end_date = end_date        # this is already a date instance
      @dates = create_date_array  # this does not include the end date, so all occupied nights
      @total_cost = total_cost || self.calc_cost
    end
    
    # Returns array of date objects for all dates 
    # start_date to end_date
    # end_date not inclusive
    def create_date_array
      @dates = []
      current_date = @start_date.dup
      
      # TIFF: you can change it to > if you need to include end date
      until current_date == @end_date
        @dates << current_date
        current_date += 1
      end
    end
    
    def self.calc_cost
      return @dates.length * @room.cost
    end
    
  end
end
