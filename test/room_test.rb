require_relative 'test_helper'

describe "Room class" do
  describe "Room initiation" do
    before do
      # Must use @ to make it accessible without a reader
      @room = Hotel::Room.new(15, 200.00)
    end
    
    it "is an instance of Room" do
      expect(@room).must_be_kind_of Hotel::Room
    end
    
    it "is set up for specific attributes and data types" do
      [:id, :cost].each do |prop|
        expect(@room).must_respond_to prop
        
        expect(@room.id).must_be_kind_of Integer
        expect(@room.cost).must_be_kind_of Float
      end
    end
  end
end
