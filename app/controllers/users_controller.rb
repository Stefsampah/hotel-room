class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:dashboard]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def dashboard
    @upcoming_bookings = current_user.bookings.where('start_date >= ?', Date.today).order(start_date: :asc)
    @past_bookings = current_user.bookings.where('end_date < ?', Date.today).order(start_date: :desc)
  end

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully deleted.'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:full_name, :last_name, :email)
  end
end
