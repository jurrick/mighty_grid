class UsersController < ApplicationController
  def index
    @users_grid = init_grid(User)
  end
end
