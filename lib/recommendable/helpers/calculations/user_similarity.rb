require "recommendable/helpers/calculations/similarity"

module Recommendable
  module Helpers
    module Calculations
      class UserSimilarity
        attr_accessor :a, :b
        attr_accessor :a_like_set, :a_dislike_set
        attr_accessor :b_like_set, :b_dislike_set

        def initialize(a, b)
          self.a = a
          self.b = b
        end

        def similarity
          ratable_classes.map(&method(:calculate)).inject(&:+)
        end

        private

        def calculate(klass)
          Similarity.new(klass, a, b).calculate
        end

        def ratable_classes
          Recommendable.config.ratable_classes
        end
      end
    end
  end
end
