class GamesController < ApplicationController
  before_action :set_game, only: [:show, :update, :destroy]

  # GET /games
  # GET /games.json

  # GET /games/new

  # redirect game to whatever step 
  def show
    respond_to do |format|
      puts Game.waiting_on_user(current_user).all
      puts @game
      if @game.image.nil?
        format.html { redirect_to :controller => :images, :action => :new, :id => @game.id }
      elsif Game.waiting_on_user(current_user).to_a.include?(@game); # not sure if this line works
        format.html { redirect_to :controller => :rankings, :action => :new, :id => @game.id }
      else
        format.html { redirect_to :controller => :results, :action => :show, :id => @game.id }
      end
    end
      
  end

  def new
    @game = Game.new
    @users = User.alphabetical.all
  end

  # POST /games
  # POST /games.json
  def create
    @game = Game.new(game_params)
    @users = User.alphabetical.all
    respond_to do |format|
      if @game.save
        format.html { redirect_to :controller => :images, :action => :new, :id => @game.id }
        #format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_params
      params.require(:game).permit(:from_user_id, :to_user_id, :image_path, :is_accepted)
    end
end
