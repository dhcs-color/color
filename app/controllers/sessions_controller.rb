class SessionsController < ApplicationController
  def create
    user = User.omniauth(env['omniauth.auth'])
    session[:user_id] = user.id
    redirect_to root_url
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end

  private
	def user_params
	  accessible = [ :name, :email ] # extend with your own params
	  accessible << [ :password, :password_confirmation ] unless params[:user][:password].blank?
	  params.require(:user).permit(accessible)
	end

end