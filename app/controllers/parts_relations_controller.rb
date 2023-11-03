class PartsRelationsController < ApplicationController
  before_action :authenticate_user!

  def new
    @part = Part.find(params[:part_id])
  end
end
