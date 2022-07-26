class PasswordResetsController < ApplicationController
  before_action :find_user, only: :create
  before_action :valid_user, :check_expiration,
                 only: %i(edit update)

  def new; end

  def create
    @user.create_reset_digest
    @user.send_password_reset_email
    flash[:info] = t "user.reset_pass"
    redirect_to root_path
  end

  def edit; end

  def update
    if params[:user][:password].blank?
      @user.errors.add :password, t("user.pass_null")
      render :edit
    elsif @user.update(user_params)
      log_in @user
      flash[:success] = t "user.done_reset"
      redirect_to @user
    else
      flash[:danger] = t "user.flash_update_fail"
      render :edit
    end
  end

  private

  def find_user
    @user = User.find_by email: params[:password_reset][:email].downcase
    return if @user

    redirect_to root_path
    flash[:danger] = t "shared.error_messages.no_info"
  end

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def valid_user
    return if @user.activated && @user.authenticated?(:reset, params[:id])
    redirect_to root_path
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "user.pass_e"
    redirect_to new_password_reset_url
  end
end
