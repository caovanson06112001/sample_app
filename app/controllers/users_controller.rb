class UsersController < ApplicationController
  before_action :find_user, except: %i(index new create)
  before_action :logged_in_user, except: %i(new create)
  before_action :correct_user, only: %i(edit update)

  def unfollow other_user
    following.delete other_user
  end

  def following
    @title = t "user.following"
    @pagy, @users = pagy @user.following
    render :show_follow
  end

  def followers
    @title = t "user.followers"
    @pagy, @users = pagy @user.followers
    render :show_follow
  end

  def index
    @pagy, @users = pagy User.latest_users, items: Settings.max_page
  end

  def new
    @user = User.new
  end

  def show
    @pagy, @microposts = pagy @user.microposts.recent_posts,
                              items: Settings.max_page
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "user.check_email"
      redirect_to root_path
    else
      flash[:danger] = t "user.failed"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = t "profile_updated"
      redirect_to @user
    else
      flash[:success] = t "profile_updated_error"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "user_deleted"
    else
      flash[:danger] = t "delete_fail"
    end
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
                                 :password_confirmation
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    redirect_to root_path
    flash[:danger] = t "shared.error_messages.no_info"
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "user.is_login"
    redirect_to login_path
  end

  def correct_user
    redirect_to root_path unless current_user? @user
  end
end
