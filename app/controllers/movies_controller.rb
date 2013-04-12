class MoviesController < ApplicationController
  helper_method :orderby_column, :orderby_direction

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @css_class1 = (params[:orderby] == "title") ? "hilite" : nil
    @css_class2 = (params[:orderby] == "release_date") ? "hilite" : nil 

    #@css_class = (params[:orderby] == "release_date" || "title") ? "hilite" : nil 

    @all_ratings = Movie.ratings

    if session[:ratings].nil?
      session[:ratings] = @all_ratings
    end

    if params[:commit] == "Refresh" && !params[:ratings].nil?
      session[:ratings] = params[:ratings].keys
    else #if session[:ratings]
      redirect_to = true
      params[:ratings] = {}
      session[:ratings].each do |e|
        params[:ratings][e] = 1
      end
    end

    if params[:orderby]
      session[:orderby] = params[:orderby]
    elsif session[:orderby]
      redirect = true
      params[:orderby] = session[:orderby]
    end

    if params[:direction]
      session[:direction] = params[:direction]
    elsif session[:direction]
      redirect = true
      params[:direction] = session[:direction]
    end
 
    @selected_ratings = session[:ratings]
    @orderby = session[:orderby]
    @direction = session[:direction]

    if redirect
      redirect_to movies_path({ :orderby => @orderby, :direction => @direction, :ratings => @selected_ratings }), { :id => "#{@orderby}_header" }
    end
    @movies = Movie.where("rating IN (?)", @selected_ratings).order(orderby_column + ' ' + orderby_direction)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private

    def orderby_column
      if Movie.column_names.include?(params[:orderby])
        return params[:orderby]
      else
        return "title"
      end
    end

    def orderby_direction
      if ["asc", "desc"].include?(params[:direction])
        return params[:direction]
      else
        return "desc"
      end
    end

end
