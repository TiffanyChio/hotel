module Hotel
  class Room
    
    attr_reader :id, :cost
    
    def initialize(id, cost)
      @id = id      # Must be Integer
      @cost = cost  # Must be Float
    end
    
    def self.generate_rooms
      array_of_room_obj = []
      
      (1..20).each do |i|
        array_of_room_obj << Hotel::Room.new(i, 200.to_f)
      end
      
      return array_of_room_obj
    end
    
  end
end
