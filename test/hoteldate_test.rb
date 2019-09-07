require_relative 'test_helper'

describe "Hotel::Date class" do
  describe "Hotel::Date instantiation" do
    before do
      @hotel_date = Hotel::Date.new(::Date.parse('2019-09-03'))
    end
    
    it "is an instance of Hotel::Date" do
      expect(@hotel_date).must_be_kind_of Hotel::Date
    end
    
    it "is set up for specific attributes and data types" do
      [:id, :occupied].each do |prop|
        expect(@hotel_date).must_respond_to prop
      end
      
      expect(@hotel_date.id).must_be_instance_of Date
      expect(@hotel_date.occupied).must_be_instance_of Hash
    end
    
  end
  
  describe "Hotel::Date instance methods" do
    before do
      @hotel_date = Hotel::Date.new(::Date.parse('2019-09-03'))
      
      @room_15 = Hotel::Room.new(15, 200.00)
      start_time = ::Date.parse('2019-09-03')
      end_time = ::Date.parse('2019-09-08')
      @reservation = Hotel::Reservation.new(id: 101, room: @room_15, start_date: start_time, end_date: end_time)
      
      @room_9 = Hotel::Room.new(9, 200.00)
      start_time = ::Date.parse('2019-09-03')
      end_time = ::Date.parse('2019-09-08')
      @hotel_block = Hotel::HotelBlock.new(id: 201, room: @room_9, start_date: start_time, end_date: end_time, cost:145)
      
      @hotel_date.add_occupancy(@reservation)
      @hotel_date.add_occupancy(@hotel_block)
    end
    
    it "can add a reservation" do
      expect(@hotel_date.occupied.keys.first).must_be_instance_of Hotel::Room
      expect(@hotel_date.occupied.values.first).must_be_instance_of Hotel::Reservation
      expect(@hotel_date.occupied[@room_15]).must_equal @reservation
    end
    
    it "can add a hotel block" do
      expect(@hotel_date.occupied.keys.last).must_be_instance_of Hotel::Room
      expect(@hotel_date.occupied.values.last).must_be_instance_of Hotel::HotelBlock
      expect(@hotel_date.occupied[@room_9]).must_equal @hotel_block
    end
    
    it "returns an array of reservations for given date, excludes hotel blocks" do
      expect(@hotel_date.list_reservations).must_be_instance_of Array
      
      expect(@hotel_date.list_reservations.length).must_equal 1
      expect(@hotel_date.list_reservations[0]).must_equal @reservation
    end
    
    it "returns an array of occupied rooms under a given date" do
      expect(@hotel_date.rooms_unavailable).must_be_instance_of Array
      
      expect(@hotel_date.rooms_unavailable.length).must_equal 2
      expect(@hotel_date.rooms_unavailable[0]).must_equal @room_15
      expect(@hotel_date.rooms_unavailable[1]).must_equal @room_9
    end
  end
end
