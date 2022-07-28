class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :find_user, only: :create
  before_action :find_relationship, only: :destroy

  def create
    current_user.follow @user
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  def destroy
    current_user.unfollow @user
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  private

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "user.login_warning"
    redirect_to login_path
  end

  def find_user
    @user = User.find_by id: params[:followed_id]
    return if @user

    flash[:danger] = t "user.follow_fail"
    redirect_to @user
  end

  def find_relationship
    @user = Relationship.find_by(id: params[:id]).followed
    return if @user

    flash[:danger] = t "user.unfollow_fail"
    redirect_to @user
  end
end
