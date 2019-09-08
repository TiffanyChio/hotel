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
      [:rooms, :reservations, :dates, :hotelblocks].each do |prop|
        expect(@sys).must_respond_to prop
      end
      
      expect(@sys.rooms).must_be_instance_of Array
      expect(@sys.rooms.first).must_be_instance_of Hotel::Room
      expect(@sys.rooms.last).must_be_instance_of Hotel::Room
      expect(@sys.reservations).must_be_instance_of Array
      expect(@sys.dates).must_be_instance_of Array
      expect(@sys.hotelblocks).must_be_instance_of Hash
    end
    
    it "allows access to the list of all rooms" do
      expect(@sys.rooms.length).must_equal 20
      expect(@sys.rooms[11].id).must_equal 12
      expect(@sys.rooms[11].cost).must_equal 200.0
    end
  end
  
  describe "room reservation creation" do
    before do
      @sys = Hotel::System.new
      @first_res = @sys.make_reservation(::Date.parse('2019-06-05'), ::Date.parse('2019-06-08'))
    end
    
    it "generates reserves a room for a given date range" do
      expect(@first_res).must_be_instance_of Hotel::Reservation
      
      expect(@first_res.id).must_equal 1
      expect(@first_res.start_date).must_equal ::Date.parse('2019-06-05')
      expect(@first_res.end_date).must_equal ::Date.parse('2019-06-08')
      expect(@first_res.cost).must_equal 200.0
      expect(@first_res.find_total_cost).must_equal (3*200.0)
    end
    
    it "adds the new reservation to the list of reservations" do
      expect(@sys.reservations.length).must_equal 1
      expect(@sys.reservations.first.id).must_equal @first_res.id
    end
    
    it "adds the date range of the reservation for which nights are occupied to the list of dates" do
      expect(@sys.dates.length).must_equal 3
      expect(@sys.dates[0].id).must_equal ::Date.parse('2019-06-05')
      expect(@sys.dates[1].id).must_equal ::Date.parse('2019-06-06')
      expect(@sys.dates[2].id).must_equal ::Date.parse('2019-06-07')
    end
    
    it "does not create a new Hotel::Date object when one already exists" do
      second_res = @sys.make_reservation(::Date.parse('2019-06-06'), ::Date.parse('2019-06-09'))
      
      expect(@sys.reservations.length).must_equal 2
      expect(@sys.dates.length).must_equal 4
      
      expect(@sys.dates[0].id).must_equal ::Date.parse('2019-06-05')
      expect(@sys.dates[1].id).must_equal ::Date.parse('2019-06-06')
      expect(@sys.dates[2].id).must_equal ::Date.parse('2019-06-07')
      expect(@sys.dates[3].id).must_equal ::Date.parse('2019-06-08')
      
      expect(@sys.dates[0].occupied.length).must_equal 1
      expect(@sys.dates[1].occupied.length).must_equal 2
      expect(@sys.dates[2].occupied.length).must_equal 2
      expect(@sys.dates[3].occupied.length).must_equal 1
    end
    
    it "creates reservations using available rooms" do
      expect(@first_res.room.id).must_equal 1
      
      second_res = @sys.make_reservation(::Date.parse('2019-06-01'), ::Date.parse('2019-06-06'))
      expect(second_res.room.id).must_equal 2
      
      third_res = @sys.make_reservation(::Date.parse('2019-06-05'), ::Date.parse('2019-06-10'))
      expect(third_res.room.id).must_equal 3
      
      fourth_res = @sys.make_reservation(::Date.parse('2019-06-07'), ::Date.parse('2019-06-10'))
      expect(fourth_res.room.id).must_equal 2
    end
    
    it "returns an error when no rooms are available" do
      19.times do
        @sys.make_reservation(::Date.parse('2019-06-05'), ::Date.parse('2019-06-08'))
      end
      
      expect{ @sys.make_reservation(::Date.parse('2019-06-05'), ::Date.parse('2019-06-08')) }.must_raise FullOccupancyError
    end
  end
  
  describe "reservation overlap verification" do
    before do
      @sys = Hotel::System.new
      @first_res = @sys.make_reservation(::Date.parse('2019-06-05'), ::Date.parse('2019-06-08'))
    end
    
    it "reservations do not impact list of available rooms outside of date range" do
      same_date_range = @sys.find_all_available_rooms(::Date.parse('2019-06-05'), ::Date.parse('2019-06-08'))
      well_before_start_date = @sys.find_all_available_rooms(::Date.parse('2019-01-11'), ::Date.parse('2019-01-22'))
      well_after_end_date = @sys.find_all_available_rooms(::Date.parse('2019-10-11'), ::Date.parse('2019-10-22'))
      
      expect(same_date_range.length).must_equal 19
      expect(well_before_start_date.length).must_equal 20
      expect(well_after_end_date.length).must_equal 20
    end
    
    it "allows reservation of room in which check-in day is the same as another reservation's check-out day" do
      start_date_is_end_date = @sys.find_all_available_rooms(::Date.parse('2019-06-08'), ::Date.parse('2019-06-10'))
      
      expect(start_date_is_end_date.length).must_equal 20
      expect(@first_res.room.id).must_equal 1
      expect(start_date_is_end_date.include? 1).must_equal false
    end
    
    it "excludes rooms for reservations if they have smaller pre-existing reservations within date range" do
      @second_res = @sys.make_reservation(::Date.parse('2019-06-06'), ::Date.parse('2019-06-10'))
      @third_res = @sys.make_reservation(::Date.parse('2019-06-07'), ::Date.parse('2019-06-09'))
      
      spans_all_res = @sys.find_all_available_rooms(::Date.parse('2019-06-01'), ::Date.parse('2019-06-12'))
      expect(spans_all_res.length).must_equal 17
    end
  end
  
  describe "list reservations for date method" do
    before do
      @sys = Hotel::System.new
    end
    
    it "returns nil when no reservations have been made for given date" do
      res_list = @sys.list_reservations_for(::Date.parse('2020-08-09'))
      
      expect(res_list).must_be_nil
    end
    
    it "returns an array of reservations for a given date" do
      first_res = @sys.make_reservation(::Date.parse('2019-06-05'), ::Date.parse('2019-06-08'))
      second_res = @sys.make_reservation(::Date.parse('2019-06-06'), ::Date.parse('2019-06-09'))
      
      res_list = @sys.list_reservations_for(::Date.parse('2019-06-06'))
      expect(res_list.length).must_equal 2
      expect(res_list.include? first_res).must_equal true
      expect(res_list.include? second_res).must_equal true
    end
  end
  
  describe "Finds Available Rooms" do
    before do
      @sys = Hotel::System.new
    end
    
    it "can find the correct room given a room_id" do
      room_obj = @sys.find_room(16)
      
      expect(room_obj).must_be_instance_of Hotel::Room
      expect(room_obj.id).must_equal 16
    end
    
    it "returns list of rooms that are not reserved for a given date range" do
      10.times do
        @sys.make_reservation(::Date.parse('2019-06-05'), ::Date.parse('2019-06-08'))
      end
      
      start_date = ::Date.parse('2019-06-05')
      end_date = ::Date.parse('2019-06-08')
      
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
      start_date = ::Date.parse('2019-09-02')
      end_date = ::Date.parse('2019-09-05')
      @sys.create_hotelblock(start_date: start_date, end_date: end_date, hb_rooms: [1,2,3,4], discount_rate: 165)
    end
    
    it "adds to the hotelblocks list" do
      expect(@sys.hotelblocks.length).must_equal 1
      expect(@sys.hotelblocks.keys.first).must_equal 1
      expect(@sys.hotelblocks.values.first).must_be_instance_of Array
      expect(@sys.hotelblocks[1].first).must_be_instance_of Hotel::HotelBlock
      expect(@sys.hotelblocks[1][2].room.id).must_equal 3
    end
    
    it "updates the hotel.dates list" do
      expect(@sys.dates.length).must_equal 3
      
      expect(@sys.dates.first).must_be_instance_of Hotel::Date
      
      expect(@sys.dates[0].id).must_equal ::Date.parse('2019-09-02')
      expect(@sys.dates[1].id).must_equal ::Date.parse('2019-09-03')
      expect(@sys.dates[2].id).must_equal ::Date.parse('2019-09-04')
    end
    
    it "excludes the room from reservation during the same date range" do
      new_reservation = @sys.make_reservation(::Date.parse('2019-09-04'), ::Date.parse('2019-09-07'))
      expect(new_reservation.room.id).must_equal 5
      
      15.times do
        @sys.make_reservation(::Date.parse('2019-09-04'), ::Date.parse('2019-09-07'))
      end
      
      expect{@sys.make_reservation(::Date.parse('2019-09-04'), ::Date.parse('2019-09-07'))}.must_raise FullOccupancyError
    end
    
    it "excludes the room from be added to hotel block during the same date range" do
      start_date = ::Date.parse('2019-09-04')
      end_date = ::Date.parse('2019-09-07')
      
      expect{@sys.create_hotelblock(start_date: start_date, end_date: end_date, hb_rooms: [2,5,6,7], discount_rate: 165)}.must_raise ArgumentError
    end
    
    it "raises an error when trying to create a block of more than 5 rooms" do
      start_date = ::Date.parse('2019-09-02')
      end_date = ::Date.parse('2019-09-05')
      
      expect{@sys.create_hotelblock(start_date: start_date, end_date: end_date, hb_rooms: [1,2,3,4,5,6], discount_rate: 165)}.must_raise ArgumentError
    end
    
    it "allows blocking of room in which check-in day is the same as another block's check-out day" do
      @sys.create_hotelblock(start_date: ::Date.parse('2019-09-05'), end_date: ::Date.parse('2019-09-09'), hb_rooms: [1,2,3,4], discount_rate: 140)
      
      expect(@sys.hotelblocks[2].first.start_date).must_equal ::Date.parse('2019-09-05')
    end
  end
  
  describe "Reserving from a HotelBlock" do
    before do
      @sys = Hotel::System.new
      start_date = ::Date.parse('2019-09-02')
      end_date = ::Date.parse('2019-09-05')
      hotel_block = @sys.create_hotelblock(start_date: start_date, end_date: end_date, hb_rooms: [7,8,9,10], discount_rate: 165)
      
      @sys.reserve_from_block(1, 8)
    end
    
    it "can make a reservation from a hotel block" do
      expect(@sys.find_open_rooms_from_block(1)).must_equal [7,9,10]
      expect(@sys.reservations[0].room.id).must_equal 8
    end
    
    it "makes reservations for the duration of the hotel block" do
      expect(@sys.reservations[0].start_date).must_equal ::Date.parse('2019-09-02')
      expect(@sys.reservations[0].end_date).must_equal ::Date.parse('2019-09-05')
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
