class UsersController < ApplicationController
  def set_location
    if current_user
      current_user.update(latitude: params[:latitude], longitude: params[:longitude])
      head :ok
    else
      head :unauthorized
    end
  end

  def update
    @user = current_user

    success = @user.update(user_params)
    success &&= @user.userable.update(address: params[:artist][:address]) if params[:artist].present? && params[:artist][:address].present?

    if success
      redirect_to user_path(@user), notice: "Profil complété avec succès."
    else
      flash[:alert] = "Erreur lors de la mise à jour du profil."
      render :edit
    end
  end

  def update_avatar
    @user = current_user
    if params[:user] && params[:user][:avatar]
      @user.avatar.attach(params[:user][:avatar])
      redirect_to user_path(@user), notice: "Avatar mis à jour avec succès."
    else
      redirect_to user_path(@user), alert: "Aucun avatar sélectionné."
    end
  end

  private

  def user_params
    params.require(:user).permit(:bio)
  end

end
