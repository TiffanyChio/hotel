module Hotel
  class Room
    
    attr_reader :id, :cost
    
    def initialize(id, cost)
      @id = id      
      @cost = cost  
    end
    
    def self.generate_rooms
      array_of_room_obj = []
      
      (1..20).each do |i|
        array_of_room_obj << Hotel::Room.new(i, 200.0)
      end
      
      return array_of_room_obj
    end
    
  end
end
