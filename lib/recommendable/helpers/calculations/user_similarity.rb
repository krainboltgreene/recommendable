module Recommendable
  module Helpers
    module Calculations
      class UserSimilarity
        attr_accessor :a, :b
        attr_accessor :similarities

        def initialize(a, b)
          self.a = a
          self.b = b
          self.similarities = ratable_classes.map(&method(:calculate))
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
          Similarity.new(klass, a, b)
        end

        def ratable_classes
          Recommendable.config.ratable_classes
        end
      end
    end
  end
end
