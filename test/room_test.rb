require_relative 'test_helper'

describe "Room class" do
  describe "Room instantiation" do
    before do
      @room = Hotel::Room.new(15, 200.00)
    end
    
    it "is an instance of Room" do
      expect(@room).must_be_kind_of Hotel::Room
    end
    
    it "is set up for specific attributes and data types" do
      [:id, :cost].each do |prop|
        expect(@room).must_respond_to prop
      end
      
      expect(@room.id).must_be_instance_of Integer
      expect(@room.cost).must_be_instance_of Float
    end
    
    describe "Room generation" do
      before do
        @room_array = Hotel::Room.generate_rooms
      end
      
      it "generates an array of rooms" do
        expect(@room_array).must_be_instance_of Array
        expect(@room_array.first).must_be_kind_of Hotel::Room
        expect(@room_array.last).must_be_kind_of Hotel::Room
      end
      
      it "generates the correct number of rooms" do
        expect(@room_array.length).must_equal 20
      end
    end
  end
end
