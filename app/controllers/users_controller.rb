class UsersController < ApplicationController
  def show
    @user = User.includes(:userable).find(params[:id])
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_back fallback_location: user_path(@user), notice: "Bio mise à jour"
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:bio)
  end

end
