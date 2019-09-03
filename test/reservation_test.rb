require_relative 'test_helper'

describe "Reservation class" do
  describe "Reservation instantiation" do
    before do
      room_15 = Hotel::Room.new(15, 200.00)
      start_time = Date.parse('2019-09-03')
      end_time = Date.parse('2019-09-08')
      
      @reservation = Hotel::Reservation.new(id: 101, room: room_15, start_date: start_time, end_date: end_time)
    end
    
    it "is an instance of Reservation" do
      expect(@reservation).must_be_kind_of Hotel::Reservation
    end
    
    it "is set up for specific attributes and data types" do
      [:id, :room, :start_date, :end_date, :date_range, :total_cost].each do |prop|
        expect(@reservation).must_respond_to prop
      end
      
      expect(@reservation.id).must_be_instance_of Integer
      expect(@reservation.room).must_be_instance_of Hotel::Room
      expect(@reservation.start_date).must_be_instance_of Date
      expect(@reservation.end_date).must_be_instance_of Date
      expect(@reservation.date_range).must_be_instance_of Array
      expect(@reservation.total_cost).must_be_instance_of Float
    end
    
    it "correctly calculates date_range" do
      expect(@reservation.date_range.length).must_equal 5
      
      expect(@reservation.date_range.first).must_equal @reservation.start_date
      expect(@reservation.date_range.last).must_equal @reservation.end_date - 1
    end
    
    it "correctly calculates total_cost" do
      expect(@reservation.total_cost).must_be_close_to 200.0*5
    end 
  end
  
  describe "raises an exception when an invalid date range is provided" do
    it "raises an error if end date is before start date" do
      room_15 = Hotel::Room.new(15, 200.00)
      start_time = Date.parse('2019-09-03')
      end_time = Date.parse('2019-09-01')
      
      expect{Hotel::Reservation.new(id: 101, room: room_15, start_date: start_time, end_date: end_time)}.must_raise ArgumentError
    end
    
    it "raises an error if end date is on same day as start date" do
      room_15 = Hotel::Room.new(15, 200.00)
      start_time = Date.parse('2019-09-03')
      end_time = Date.parse('2019-09-03')
      
      expect{Hotel::Reservation.new(id: 101, room: room_15, start_date: start_time, end_date: end_time)}.must_raise ArgumentError
    end
  end
end