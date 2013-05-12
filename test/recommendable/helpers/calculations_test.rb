require "test_helper"

class CalculationsTest < MiniTest::Unit::TestCase
  def setup
    $debug = false
    @user = Factory(:user)
    5.times  { |x| instance_variable_set(:"@user#{x+1}",  Factory(:user))  }
    10.times { |x| instance_variable_set(:"@movie#{x+1}", Factory(:movie)) }
    10.times { |x| instance_variable_set(:"@book#{x+1}",  Factory(:book))  }

    [@movie1, @movie2, @movie3, @book4, @book5, @book6].each { |obj| @user.like(obj) }
    [@book1, @book2, @book3, @movie4, @movie5, @movie6].each { |obj| @user.dislike(obj) }

    # @user.similarity_with(@user1) should ==  1.0
    [@movie1, @movie2, @movie3, @book4, @book5, @book6, @book7, @book8, @movie9, @movie10].each { |obj| @user1.like(obj) }
    [@book1, @book2, @book3, @movie4, @movie5, @movie6, @movie7, @movie8, @book9, @book10].each { |obj| @user1.dislike(obj) }

    # @user.similarity_with(@user2) should ==  0.25
    [@movie1, @movie2, @movie3, @book4, @book5, @book6].each { |obj| @user2.like(obj) }
    [@book1, @book2, @book3].each { |obj| @user2.like(obj) }

    # @user.similarity_with(@user3) should ==  0.0
    [@movie1, @movie2, @movie3].each { |obj| @user3.like(obj) }
    [@book1, @book2, @book3].each { |obj| @user3.like(obj) }

    # @user.similarity_with(@user4) should == -0.25
    [@movie1, @movie2, @movie3].each { |obj| @user4.like(obj) }
    [@book1, @book2, @book3, @movie4, @movie5, @movie6].each { |obj| @user4.like(obj) }

    # @user.similarity_with(@user5) should == -1.0
    [@movie1, @movie2, @movie3, @book4, @book5, @book6].each { |obj| @user5.dislike(obj) }
    [@book1, @book2, @book3, @movie4, @movie5, @movie6].each { |obj| @user5.like(obj) }
  end

  def test_similarity_between_calculates_correctly
    assert_similarity(1.0, @user, @user1)
    assert_similarity(0.25, @user, @user2)
    assert_similarity(0, @user, @user3)
    assert_similarity(-0.25, @user, @user4)
    assert_similarity(-1.0, @user, @user5)
  end

  def test_update_recommendations_ignores_rated_items
    Recommendable::Helpers::Calculations.update_similarities_for(@user.id)
    Recommendable::Helpers::Calculations.update_recommendations_for(@user.id)

    movies = @user.liked_movies + @user.disliked_movies
    books  = @user.liked_books  + @user.disliked_books

    movies.each { |m| refute_includes @user.recommended_movies, m }
    books.each  { |b| refute_includes @user.recommended_books,  b }
  end

  def test_predict_for_returns_predictions
    Recommendable::Helpers::Calculations.update_similarities_for(@user.id)
    assert_predict(1.0, @user, @book7)
    assert_predict(-1.0, @user, @book9)
    assert_predict(-1.0, @user, @book10)
    assert_predict(-1.0, @user, @movie7)
    assert_predict(1.0, @user, @movie8)
    assert_predict(1.0, @user, @movie10)
  end

  def teardown
    Recommendable.redis.flushdb
  end

  def assert_predict(value, user, resource)
    assert_calculation(:predict_for, value, user.id, resource.class, resource.id)
  end

  def assert_similarity(value, a, b)
    assert_calculation(:similarity_between, value, a.id, b.id)
  end

  def assert_calculation(method, value, *arguments)
    expected = value
    actual = Recommendable::Helpers::Calculations.send(method, *arguments)
    assert_equal(expected, actual)
  end
end
