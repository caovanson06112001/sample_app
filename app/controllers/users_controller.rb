class UsersController < ApplicationController
  def new
    @user = User.new(name: "cao son", email: "caoson@gmail.com")
  end
end
