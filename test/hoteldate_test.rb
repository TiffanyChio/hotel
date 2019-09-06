require_relative 'test_helper'

describe "HotelDate class" do
  describe "HotelDate instantiation" do
    before do
      @hotel_date = Hotel::HotelDate.new(Date.parse('2019-09-03'))
    end
    
    it "is an instance of HotelDate" do
      expect(@hotel_date).must_be_kind_of Hotel::HotelDate
    end
    
    it "is set up for specific attributes and data types" do
      [:id, :occupied].each do |prop|
        expect(@hotel_date).must_respond_to prop
      end
      
      expect(@hotel_date.id).must_be_instance_of Date
      expect(@hotel_date.occupied).must_be_instance_of Hash
    end
    
  end
  
  describe "HotelDate instance methods" do
    before do
      @hotel_date = Hotel::HotelDate.new(Date.parse('2019-09-03'))
      
      @room_15 = Hotel::Room.new(15, 200.00)
      start_time = Date.parse('2019-09-03')
      end_time = Date.parse('2019-09-08')
      @reservation = Hotel::Reservation.new(id: 101, room: @room_15, start_date: start_time, end_date: end_time)
      
      @hotel_date.add_occupancy(@reservation)
    end
    
    it "can add a reservation" do
      expect(@hotel_date.occupied.keys.first).must_be_instance_of Hotel::Room
      expect(@hotel_date.occupied.values.first).must_be_instance_of Hotel::Reservation
      expect(@hotel_date.occupied[@room_15]).must_equal @reservation
    end
    
    it "returns an array of reservations under a given date" do
      expect(@hotel_date.list_reservations).must_be_instance_of Array
      
      expect(@hotel_date.list_reservations.length).must_equal 1
      expect(@hotel_date.list_reservations[0]).must_equal @reservation
    end
    
    it "returns an array of occupied rooms under a given date" do
      expect(@hotel_date.rooms_occupied).must_be_instance_of Array
      
      expect(@hotel_date.rooms_occupied.length).must_equal 1
      expect(@hotel_date.rooms_occupied[0]).must_equal @room_15
    end
  end
end
