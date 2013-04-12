class Movie < ActiveRecord::Base
  def self.ratings
    ['G','NC-17','PG','PG-13','R']
  end

  #def self.ratings
  #	 ratings = []
  #  Movie.select(:rating).each do |r|
  #  ratings << r.rating.upcase
  #  end
  #  return ratings.uniq!.sort!
  #end

  #def initialize
  #	@selected_ratings = Movie.ratigns
  #end
end
