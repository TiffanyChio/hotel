require_relative 'test_helper'

describe "HotelDate class" do
  describe "HotelDate instantiation" do
    before do
      @date_1 = Hotel::HotelDate.new(Date.parse('2019-09-03'))
    end
    
    it "is an instance of HotelDate" do
      expect(@date_1).must_be_kind_of Hotel::HotelDate
    end
    
    it "is set up for specific attributes and data types" do
      [:id, :occupied].each do |prop|
        expect(@date_1).must_respond_to prop
      end
      
      expect(@date_1.id).must_be_instance_of Date
      expect(@date_1.occupied).must_be_instance_of Hash
    end
    
  end
  
  # TIFF: I think you need to clean this up. Esp the set-up portion.
  it "can add a add_reservation" do
    id = Date.parse('2019-09-03')
    @date_2 = Hotel::HotelDate.new(id)
    
    room_15 = Hotel::Room.new(15, 200.00)
    start_time = Date.parse('2019-09-03')
    end_time = Date.parse('2019-09-08')
    @reservation = Hotel::Reservation.new(id: 101, room: room_15, start_date: start_time, end_date: end_time)
    
    @date_2.add_reservation(@reservation)
    
    expect(@date_2.occupied.keys.first).must_be_instance_of Integer
    expect(@date_2.occupied.values.first).must_be_instance_of Hotel::Reservation
    expect(@date_2.occupied[15]).must_equal @reservation
  end
  
end
