module Recommendable
  module Helpers
    module Calculations
      class VoteDifference
        attr_accessor :aset, :bset

        def initialize(aset, bset)
          self.aset = aset
          self.bset = bset
        end

        def size
          Recommendable.redis.sinter(aset, bset).size
        end
      end
    end
  end
end
