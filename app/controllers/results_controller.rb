class ResultsController < ApplicationController
  before_action :set_game, only: [:show]

  # GET /results
  # GET /results.json

  # GET /results/1
  # GET /results/1.json
  def show
    @user_result = Result.get_result(@game.id, current_user.id)
    @other_result = @user_result.other_result
  end

  # POST /results
  # POST /results.json
  def create
    @result = Result.new(result_params)

    respond_to do |format|
      if @result.save
        format.html { redirect_to @result, notice: 'Result was successfully created.' }
        format.json { render :show, status: :created, location: @result }
      else
        format.html { render :new }
        format.json { render json: @result.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def result_params
      params.require(:result).permit(:user_id, :ranking_id, :score)
    end
end
