class Movie < ActiveRecord::Base
  def self.all_ratings
    return ['G', 'PG', 'PG-13', 'R']
  end
  
  def self.with_ratings(ratings_list)
  # if ratings_list is an array such as ['G', 'PG', 'R'], retrieve all
  #  movies with those ratings
  # if ratings_list is nil, retrieve ALL movies
    if ratings_list.nil? or ratings_list.length() == 0
      return Movie.all
    else 
      return Movie.where(rating: ratings_list)
    end
  end
end
