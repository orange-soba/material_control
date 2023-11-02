class UsersController < ApplicationController
  before_action :authenticate_user!
  
  def show
    @products = current_user.parts.where(finished: true)
    @parts = current_user.parts.where(finished: false)
  end
end
