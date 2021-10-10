class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings

    # redirect when params has no key but session has key
    if (!params.has_key?(:ratings) && session.has_key?(:ratings))
      redirect_to movies_path(:ratings => Hash[session[:ratings].collect{|key| [key, '1']}], :sort_by => params[:sort_by]) and return 
    elsif (!params.has_key?(:sort_by) && session.has_key?(:sort_by))
      redirect_to movies_path(:ratings => params[:ratings], :sort_by => session[:sort_by]) and return 
    end 
    
    if !params.has_key?(:ratings)
      @ratings_to_show = @all_ratings
    else 
      @ratings_to_show = params[:ratings].keys
    end
    @ratings_to_show_hash = Hash[@ratings_to_show.collect{|key| [key, '1']}]
    session[:ratings] = @ratings_to_show
    @movies = Movie.with_ratings(@ratings_to_show)
    
    @sort_by = params[:sort_by]
    @movies = @movies.order(@sort_by) if @sort_by != ''
    session[:sort_by] = @sort_by
    @title_class = "hilite bg-warning" if @sort_by == "title"
    @release_date_class = "hilite bg-warning" if @sort_by == "release_date"   
      
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
