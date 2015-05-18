class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :set_user, only: [:show]

  def index
    @users = User.winners
  end

  def show
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

end