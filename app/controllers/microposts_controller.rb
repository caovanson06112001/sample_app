class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(:create :destroy)
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params
    if @micropost.save
      flash[:success] = t "post.ss"
      redirect_to root_path
    else
      @feed_items = current_user.feed.page params[:page]
      flash.now[:danger] = t "post.fails"
      render "static_pages/home"
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "post.delete"
    else
      flash[:danger] = t "post.delete-failed"
    end
    redirect_to request.referer || root_path
  end

  private

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "please_login"
    redirect_to login_path
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return if @micropost

    flash[:danger] = t "micropost_invalid"
    redirect_to request.referer || root_path
  end

  def micropost_params
    params.require(:micropost).permit :content, :image
  end
end
