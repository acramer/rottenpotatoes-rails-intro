class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings = Movie.select(:rating).order(:rating).map(&:rating).uniq
    @selected_ratings = @all_ratings
    
    session[:ratings] = params[:ratings] if params[:ratings] != nil
    session[:order_by] = params[:order_by] if params[:order_by] != nil
    
    if ((!session[:ratings].nil? && (params[:ratings].nil? || (params[:ratings].keys == @all_ratings && params[:ratings].keys != session[:ratings].keys))) || (params[:order_by] != session[:order_by] && params[:order_by].nil? && !session[:order_by].nil?))
      flash.keep
      redirect_to :order_by => session[:order_by], :ratings => session[:ratings]
    end
    
    
    if params[:ratings]
      @selected_ratings = params[:ratings].keys
    end
    puts @selected_ratings

    @movies = Movie.all.where(:rating => @selected_ratings)
    if params[:order_by] != nil
      @movies = Movie.order(params[:order_by]).where(:rating => @selected_ratings)
    end
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
  

end
