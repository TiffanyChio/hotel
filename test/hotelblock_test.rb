require_relative 'test_helper'

describe "HotelBlock class" do
  describe "HotelBlock instantiation" do
    before do
      room_15 = Hotel::Room.new(15, 200.00)
      start_time = Date.parse('2019-09-03')
      end_time = Date.parse('2019-09-08')
      
      @hotelblock = Hotel::HotelBlock.new(id: 101, room: room_15, start_date: start_time, end_date: end_time, cost: 100)
    end
    
    it "is an instance of HotelBlock" do
      expect(@hotelblock).must_be_kind_of Hotel::HotelBlock
    end
    
    it "is set up for specific attributes and data types" do
      [:id, :room, :start_date, :end_date, :cost, :status].each do |prop|
        expect(@hotelblock).must_respond_to prop
      end
      
      expect(@hotelblock.id).must_be_instance_of Integer
      expect(@hotelblock.room).must_be_instance_of Hotel::Room
      expect(@hotelblock.start_date).must_be_instance_of Date
      expect(@hotelblock.end_date).must_be_instance_of Date
      expect(@hotelblock.status).must_be_instance_of Symbol
    end
    
    it "correctly assigns cost value" do
      expect(@hotelblock.cost).must_be_close_to 100.0
    end 
    
    # TIFF PUT THIS SOMEWHERE ELSE
    it "correctly calculates total_cost" do
      expect(@hotelblock.find_total_cost).must_be_close_to 100.0*5
    end
  end
  
  describe "the status of hotelblock" do
    before do
      room_15 = Hotel::Room.new(15, 200.00)
      start_time = Date.parse('2019-09-03')
      end_time = Date.parse('2019-09-08')
      
      @hotelblock = Hotel::HotelBlock.new(id: 101, room: room_15, start_date: start_time, end_date: end_time, cost: 100)
    end
    
    it "initializes hotelblocks with :AVAILABLE" do
      expect(@hotelblock.status).must_equal :AVAILABLE
    end
    
    it "can be changed to :UNVAILABLE with the change_status method" do
      @hotelblock.change_status
      expect(@hotelblock.status).must_equal :UNAVAILABLE
    end
  end
  
  describe "raises an exception when an invalid date range is provided" do
    it "raises an error if end date is before start date" do
      room_15 = Hotel::Room.new(15, 200.00)
      start_time = Date.parse('2019-09-03')
      end_time = Date.parse('2019-09-01')
      
      expect{Hotel::HotelBlock.new(id: 101, room: room_15, start_date: start_time, end_date: end_time, cost: 100)}.must_raise ArgumentError
    end
    
    it "raises an error if end date is on same day as start date" do
      room_15 = Hotel::Room.new(15, 200.00)
      start_time = Date.parse('2019-09-03')
      end_time = Date.parse('2019-09-03')
      
      expect{Hotel::HotelBlock.new(id: 101, room: room_15, start_date: start_time, end_date: end_time, cost: 100)}.must_raise ArgumentError
    end
  end
end
