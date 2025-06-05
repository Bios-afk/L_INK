class UsersController < ApplicationController
  def show
    @user = User.includes(:userable).find(params[:id])
  end

  def update
    @user = current_user

    success = @user.update(user_params)
    success &&= @user.userable.update(address: params[:user][:address]) if params[:user][:address].present?

    if success
      redirect_to user_path(@user), notice: "Profil complété avec succès."
    else
      flash[:alert] = "Erreur lors de la mise à jour du profil."
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:bio)
  end

end
