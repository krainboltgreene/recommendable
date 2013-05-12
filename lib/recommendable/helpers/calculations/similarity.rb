module Recommendable
  module Helpers
    module Calculations
      class Similarity
        attr_accessor :aliked, :adisliked
        attr_accessor :bliked, :bdisliked

        def initialize(klass, a, b)
          self.aliked = liked_set_for(klass, a)
          self.adisliked = disliked_set_for(klass, a)
          self.bliked = liked_set_for(klass, b)
          self.bdisliked = disliked_set_for(klass, b)
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
          Recommendable.redis.scard(aliked)
        end

        def disliked_count
          Recommendable.redis.scard(adisliked)
        end

        def agreements
          liked_intersection + disliked_intersection
        end

        def disagreements
          liked_divergence + disliked_divergence
        end

        def liked_intersection
          VoteDifference.new(aliked, bliked).size
        end

        def disliked_intersection
          VoteDifference.new(adisliked, bdisliked).size
        end

        def liked_divergence
          VoteDifference.new(aliked, bdisliked).size
        end

        def disliked_divergence
          VoteDifference.new(adisliked, bliked).size
        end
      end
    end
  end
end
