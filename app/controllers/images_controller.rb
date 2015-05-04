class ImagesController < ApplicationController
  def new
  	@image = Image.new
  end

  def create
  	@image = Image.new(image_params)

    respond_to do |format|
      if @image.save
        format.html { redirect_to url_for('/games/#{@image.game_id}/ranking')}
        #format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def game_params
      params.require(:image).permit(:game_id, :file)
    end

end
