module Hotel
  class Room
    
    attr_reader :id, :cost
    
    def initialize(id, cost)
      @id = id      # Must be Integer
      @cost = cost  # Must be Float
    end
    
  end
end
