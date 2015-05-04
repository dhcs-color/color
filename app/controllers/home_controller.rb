class HomeController < ApplicationController
  before_action :set_game, only: [:edit, :update, :destroy]

  # GET /games
  # GET /games.json

  # GET /games/new
  def index
    unless current_user.nil?
      @not_accepted_games = Game.users_games(current_user).pending.by_date.all
      @waiting_on_user = Game.waiting_on_user(current_user).by_date.all
      @waiting_on_friend = Game.waiting_on_friend(current_user).by_date.all
      @finished_games = Games.completed(current_user).by_date.all? { |e|  }
    end
  end

  # reject game
  def destroy
    @game.destroy
    respond_to do |format|
      format.html { redirect_to :home }
      format.json { head :no_content }
    end
  end

  # accept game
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to :home }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit }
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
