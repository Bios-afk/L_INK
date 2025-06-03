class UsersController < ApplicationController
  def show
    @user = User.includes(:userable).find(params[:id])
  end
end
