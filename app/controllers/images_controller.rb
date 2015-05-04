class ImagesController < ApplicationController
  before_action :set_game, only: :new

  def new
  	@image = Image.new
  end

  def create
  	@image = Image.new(image_params)

    respond_to do |format|
      if @image.save
        format.html { redirect_to :controller => :results, :action => :new, :id => @game.id }
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

    def image_params
      params.require(:image).permit(:game_id, :file)
    end

end
