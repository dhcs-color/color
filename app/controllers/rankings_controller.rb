class RankingsController < ApplicationController
  before_action :set_game, only: [:new, :create]

  # GET /rankings/new
  def new
    @ranking = Ranking.new
  end

  # POST /rankings
  # POST /rankings.json
  def create
    @ranking = Ranking.new(ranking_params)

    respond_to do |format|
      if @ranking.save
        format.html { redirect_to :home }
        result = Result.create_result
        if !result.save
          format.json { render json: result.errors, status: :unprocessable_entity }
        end
        #format.json { render :show, status: :created, location: @ranking }
      else
        format.html { render :new }
        format.json { render json: @ranking.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ranking
      @ranking = Ranking.find(params[:id])
    end

    def set_game
      @game = Game.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ranking_params
      params.require(:ranking).permit(:game_id, :user_id, :color1, :color2, :color3, :color4)
    end
end
