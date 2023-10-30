class PartsController < ApplicationController
  before_action :redirect_to_root

  def new
  end
  
  private

  def redirect_to_root
    return if user_signed_in?

    redirect_to root_path
  end
end
