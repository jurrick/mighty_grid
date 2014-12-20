class UsersController < ApplicationController
  def index
    @users_grid = UsersGrid.new(params)
  end
end
