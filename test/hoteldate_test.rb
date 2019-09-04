require_relative 'test_helper'

describe "HotelDate class" do
  describe "HotelDate instantiation" do
    before do
      id = Date.parse('2019-09-03')
      
      rooms_list = []
      (1..5).each do |i|
        rooms_list << Hotel::Room.new(i, 200.00)
      end
      
      @date_1 = Hotel::HotelDate.new(id, rooms_list)
    end
    
    it "is an instance of HotelDate" do
      expect(@date_1).must_be_kind_of Hotel::HotelDate
    end
    
    it "is set up for specific attributes and data types" do
      [:id, :availability].each do |prop|
        expect(@date_1).must_respond_to prop
      end
      
      expect(@date_1.id).must_be_instance_of Date
      expect(@date_1.availability).must_be_instance_of Hash
      expect(@date_1.availability.keys.first).must_be_instance_of Integer
      expect(@date_1.availability.values.first).must_be_instance_of Symbol
    end
    
    it "correctly sets up availability hash" do
      expect(@date_1.availability.length).must_equal 5
      expect(@date_1.availability[3]).must_equal :AVAILABLE
    end
  end
  
  # TIFF: I think you need to clean this up. Esp the set-up portion.
  it "can add a add_reservation" do
    id = Date.parse('2019-09-03')
    
    rooms_list = []
    (1..20).each do |i|
      rooms_list << Hotel::Room.new(i, 200.00)
    end
    
    @date_2 = Hotel::HotelDate.new(id, rooms_list)
    
    room_15 = Hotel::Room.new(15, 200.00)
    start_time = Date.parse('2019-09-03')
    end_time = Date.parse('2019-09-08')
    
    @reservation = Hotel::Reservation.new(id: 101, room: room_15, start_date: start_time, end_date: end_time)
    
    @date_2.add_reservation(@reservation)
    
    expect(@date_2.availability[15]).must_equal @reservation
    expect(@date_2.availability[5]).must_equal :AVAILABLE
  end
  
end
