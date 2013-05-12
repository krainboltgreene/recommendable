module Recommendable
  module Helpers
    module Calculations
      class UserSimilarity
        attr_accessor :auser, :buser
        attr_accessor :similarities

        def initialize(auser, buser, classes)
          self.auser = auser
          self.buser = buser
          self.similarities = classes.map(&method(:calculate))
        end

        def calculate!
          similarity / count
        end

        private

        def count
          similarities.map(&:count).inject(&:+).to_f
        end

        def similarity
          similarities.map(&:score).inject(&:+)
        end

        def calculate(klass)
          Similarity.new(klass, auser, buser)
        end
      end
    end
  end
end
