class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end


  def index
    @all_ratings = Movie.select(:rating).map(&:rating).uniq
    session[:checked] ||=  @all_ratings
    session[:sort] ||= "title"
    if params[:ratings]
      session[:checked] = []
      params[:ratings].each_key {|rating| session[:checked].push (rating)}
    end
    if params[:sort]
      session[:sort] = params[:sort]
    end
    @hilite = session[:sort]
    @movies = Movie.where(rating: session[:checked]).order(session[:sort])
    unless params[:ratings] and params[:sort]
      temp_hash = {sort:  session[:sort]}
      session[:checked].each {|rating| temp_hash["ratings[#{rating}]"] = "1"}
      flash.keep
      redirect_to movies_path(temp_hash)
    end
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

end
