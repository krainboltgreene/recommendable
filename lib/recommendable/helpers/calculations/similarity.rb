module Recommendable
  module Helpers
    module Calculations
      class Similarity
        attr_accessor :a_liked_set, :a_disliked_set
        attr_accessor :b_liked_set, :b_disliked_set

        def initialize(klass, a, b)
          self.a_liked_set = liked_set_for(klass, a)
          self.a_disliked_set = disliked_set_for(klass, a)
          self.b_liked_set = liked_set_for(klass, b)
          self.b_disliked_set = disliked_set_for(klass, b)
        end

        def calculate
          similarity / (liked_count + disliked_count).to_f
        end

        private

        def liked_set_for(klass, id)
          Recommendable::Helpers::RedisKeyMapper.liked_set_for(klass, id)
        end

        def disliked_set_for(klass, id)
          Recommendable::Helpers::RedisKeyMapper.disliked_set_for(klass, id)
        end

        def similarity
          agreements - disagreements
        end

        def liked_count
          Recommendable.redis.scard(a_liked_set)
        end

        def disliked_count
          Recommendable.redis.scard(a_disliked_set)
        end

        def agreements
          liked_intersection + disliked_intersection
        end

        def disagreements
          liked_difference + disliked_difference
        end

        def liked_intersection
          Recommendable.redis.sinter(a_liked_set, b_liked_set).size
        end

        def disliked_intersection
          Recommendable.redis.sinter(a_disliked_set, b_disliked_set).size
        end

        def liked_difference
          Recommendable.redis.sinter(a_liked_set, b_disliked_set).size
        end

        def disliked_difference
          Recommendable.redis.sinter(a_disliked_set, b_liked_set).size
        end
      end
    end
  end
end
