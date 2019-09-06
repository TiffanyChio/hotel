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
      [:rooms, :reservations, :hoteldates, :hotelblocks].each do |prop|
        expect(@sys).must_respond_to prop
      end
      
      expect(@sys.rooms).must_be_instance_of Array
      expect(@sys.rooms.first).must_be_instance_of Hotel::Room
      expect(@sys.rooms.last).must_be_instance_of Hotel::Room
      expect(@sys.reservations).must_be_instance_of Array
      expect(@sys.hoteldates).must_be_instance_of Array
      expect(@sys.hotelblocks).must_be_instance_of Hash
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
    
    it "returns a new reservation with correct dates" do
      expect(@first_res).must_be_instance_of Hotel::Reservation
      
      expect(@first_res.id).must_equal 1
      expect(@first_res.start_date).must_equal Date.parse('2019-06-05')
      expect(@first_res.end_date).must_equal Date.parse('2019-06-08')
      expect(@first_res.cost).must_equal 200.0
      expect(@first_res.find_total_cost).must_equal (3*200.0)
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
    
    it "creates reservations using available rooms" do
      expect(@first_res.room.id).must_equal 1
      
      second_res = @sys.make_reservation(start_date: '2019-06-01', end_date: '2019-06-06')
      expect(second_res.room.id).must_equal 2
      
      third_res = @sys.make_reservation(start_date: '2019-06-05', end_date: '2019-06-10')
      expect(third_res.room.id).must_equal 3
      
      fourth_res = @sys.make_reservation(start_date: '2019-06-07', end_date: '2019-06-10')
      expect(fourth_res.room.id).must_equal 2
    end
    
    it "returns an error when no rooms are available" do
      19.times do
        @sys.make_reservation(start_date: '2019-06-05', end_date: '2019-06-08')
      end
      
      expect{ @sys.make_reservation(start_date: '2019-06-05', end_date: '2019-06-08') }.must_raise ArgumentError
    end
  end
  
  describe "list_reservations_for method" do
    before do
      @sys = Hotel::System.new
    end
    
    it "returns nil when no reservations have been made for given date" do
      res_list = @sys.list_reservations_for('2020-08-09')
      
      expect(res_list).must_be_nil
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
  
  describe "FILL IN NAME" do
    before do
      @sys = Hotel::System.new
    end
    
    it "can find the correct room given a room_id" do
      room_obj = @sys.find_room(16)
      
      expect(room_obj).must_be_instance_of Hotel::Room
      expect(room_obj.id).must_equal 16
    end
    
    it "finds all available rooms" do
      10.times do
        @sys.make_reservation(start_date: '2019-06-05', end_date: '2019-06-08')
      end
      
      start_date = Date.parse('2019-06-05')
      end_date = Date.parse('2019-06-08')
      
      available_rooms = @sys.find_all_available_rooms(start_date, end_date)
      
      expect(available_rooms).must_be_instance_of Array
      expect(available_rooms.length).must_equal 10
      expect(available_rooms.first.id).must_equal 11
      expect(available_rooms.last.id).must_equal 20
    end
  end
  
  describe "HotelBlock Creation" do
    before do
      @sys = Hotel::System.new
      @sys.create_hotelblock(start_date: '2019-09-02', end_date: '2019-09-05', hb_rooms: [1,2,3,4], discount_rate: 165)
    end
    
    it "adds to the hotelblocks list" do
      expect(@sys.hotelblocks.length).must_equal 1
      expect(@sys.hotelblocks.keys.first).must_equal 1
      expect(@sys.hotelblocks.values.first).must_be_instance_of Array
      expect(@sys.hotelblocks[1].first).must_be_instance_of Hotel::HotelBlock
      expect(@sys.hotelblocks[1][2].room.id).must_equal 3
    end
    
    it "updates the hoteldates list" do
      expect(@sys.hoteldates.length).must_equal 3
      
      expect(@sys.hoteldates.first).must_be_instance_of Hotel::HotelDate
      
      expect(@sys.hoteldates[0].id).must_equal Date.parse('2019-09-02')
      expect(@sys.hoteldates[1].id).must_equal Date.parse('2019-09-03')
      expect(@sys.hoteldates[2].id).must_equal Date.parse('2019-09-04')
    end
    
    it "excludes the room from reservation during the same date range" do
      new_reservation = @sys.make_reservation(start_date: '2019-09-04', end_date: '2019-09-07')
      expect(new_reservation.room.id).must_equal 5
      
      15.times do
        @sys.make_reservation(start_date: '2019-09-04', end_date: '2019-09-07')
      end
      
      expect{@sys.make_reservation(start_date: '2019-09-04', end_date: '2019-09-07')}.must_raise ArgumentError
    end
    
    it "excludes the room from be added to hotel block during the same date range" do
      expect{@sys.create_hotelblock(start_date: '2019-09-04', end_date: '2019-09-07', hb_rooms: [2,5,6,7], discount_rate: 165)}.must_raise ArgumentError
    end
    
    it "raises an error when trying to create a block of more than 5 rooms" do
      expect{@sys.create_hotelblock(start_date: '2019-09-02', end_date: '2019-09-05', hb_rooms: [1,2,3,4,5,6], discount_rate: 165)}.must_raise ArgumentError
    end
  end
  
  describe "Reserving from a HotelBlock" do
    before do
      @sys = Hotel::System.new
      hotel_block = @sys.create_hotelblock(start_date: '2019-09-02', end_date: '2019-09-05', hb_rooms: [7,8,9,10], discount_rate: 165)
      
      @sys.reserve_from_block(1, 8)
    end
    
    it "can make a reservation from a hotel block" do
      expect(@sys.find_open_rooms_from_block(1)).must_equal [7,9,10]
      expect(@sys.reservations[0].room.id).must_equal 8
    end
    
    it "makes reservations for the duration of the hotel block" do
      expect(@sys.reservations[0].start_date).must_equal Date.parse('2019-09-02')
      expect(@sys.reservations[0].end_date).must_equal Date.parse('2019-09-05')
    end
    
    it "returns all available rooms in a HotelBlock" do
      available_rooms = @sys.find_open_rooms_from_block(1)
      
      expect(available_rooms.length).must_equal 3
      expect(available_rooms).must_equal [7,9,10]
    end
    
    it "raises an error when reserving a room that's already reserved" do
      expect{ @sys.reserve_from_block(1, 8) }.must_raise ArgumentError
    end
    
    it "adds the reservation made from the HotelBlock into the Reservations list" do
      @sys.reserve_from_block(1, 10)
      
      expect(@sys.reservations[1].room.id).must_equal 10
      expect(@sys.reservations[1]).must_be_instance_of Hotel::Reservation
    end
    
    it "returns nil if no rooms are available" do
      @sys.reserve_from_block(1, 10)
      @sys.reserve_from_block(1, 7)
      @sys.reserve_from_block(1, 9)
      
      available_rooms = @sys.find_open_rooms_from_block(1)
      
      expect(available_rooms).must_equal []
    end
  end
end
