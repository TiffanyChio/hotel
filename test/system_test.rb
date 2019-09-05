require_relative 'test_helper'

describe "System class" do
  describe "System instantiation" do
    before do
      @sys = Hotel::System.new
    end
    
    it "is an instance of System" do
      expect(@sys).must_be_instance_of Hotel::System
    end
    
    it "is set up for specific attributes and data types" do
      [:rooms, :reservations, :hoteldates].each do |prop|
        expect(@sys).must_respond_to prop
      end
      
      expect(@sys.rooms).must_be_instance_of Array
      expect(@sys.rooms.first).must_be_instance_of Hotel::Room
      expect(@sys.rooms.last).must_be_instance_of Hotel::Room
      expect(@sys.reservations).must_be_instance_of Array
      expect(@sys.hoteldates).must_be_instance_of Array
    end
    
    it "executes generate rooms method correctly" do
      expect(@sys.rooms.length).must_equal 20
      expect(@sys.rooms[11].id).must_equal 12
      expect(@sys.rooms[11].cost).must_equal 200.0
    end
  end
  
  describe "making a room reservation" do
    before do
      @sys = Hotel::System.new
      @first_res = @sys.make_reservation(start_date: '2019-06-05', end_date: '2019-06-08') 
    end
    
    it "can find the correct room given a room_id" do
      room_obj = @sys.find_room(16)
      
      expect(room_obj).must_be_instance_of Hotel::Room
      expect(room_obj.id).must_equal 16
    end
    
    it "returns a new reservation with correct dates" do
      expect(@first_res).must_be_instance_of Hotel::Reservation
      
      expect(@first_res.id).must_equal 1
      expect(@first_res.start_date).must_equal Date.parse('2019-06-05')
      expect(@first_res.end_date).must_equal Date.parse('2019-06-08')
      expect(@first_res.total_cost).must_equal (3*200.0)
    end
    
    it "adds the new reservation to the list of reservations" do
      expect(@sys.reservations.length).must_equal 1
      expect(@sys.reservations.first.id).must_equal @first_res.id
    end
    
    it "adds the date range of the reservation for which nights are occupied to the list of dates" do
      expect(@sys.hoteldates.length).must_equal 3
      expect(@sys.hoteldates[0].id).must_equal Date.parse('2019-06-05')
      expect(@sys.hoteldates[1].id).must_equal Date.parse('2019-06-06')
      expect(@sys.hoteldates[2].id).must_equal Date.parse('2019-06-07')
    end
    
    it "does not create a new HotelDate object when one already exists" do
      second_res = @sys.make_reservation(start_date: '2019-06-06', end_date: '2019-06-09')
      
      expect(@sys.reservations.length).must_equal 2
      expect(@sys.hoteldates.length).must_equal 4
      
      expect(@sys.hoteldates[0].id).must_equal Date.parse('2019-06-05')
      expect(@sys.hoteldates[1].id).must_equal Date.parse('2019-06-06')
      expect(@sys.hoteldates[2].id).must_equal Date.parse('2019-06-07')
      expect(@sys.hoteldates[3].id).must_equal Date.parse('2019-06-08')
      
      expect(@sys.hoteldates[0].occupied.length).must_equal 1
      expect(@sys.hoteldates[1].occupied.length).must_equal 2
      expect(@sys.hoteldates[2].occupied.length).must_equal 2
      expect(@sys.hoteldates[3].occupied.length).must_equal 1
    end
  end
  
  describe "list_reservations_for method" do
    before do
      @sys = Hotel::System.new
    end
    
    it "returns nil when no reservations have been made yet" do
      res_list = @sys.list_reservations_for('2020-08-09')
      
      expect(res_list).must_equal nil
    end
    
    it "returns an array of reservations for a given date" do
      first_res = @sys.make_reservation(start_date: '2019-06-05', end_date: '2019-06-08')
      second_res = @sys.make_reservation(start_date: '2019-06-06', end_date: '2019-06-09')
      
      res_list = @sys.list_reservations_for('2019-06-06')
      expect(res_list.length).must_equal 2
      expect(res_list.include? first_res).must_equal true
      expect(res_list.include? second_res).must_equal true
    end
  end
  
end
