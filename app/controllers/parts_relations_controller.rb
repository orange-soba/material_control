class PartsRelationsController < ApplicationController
  before_action :authenticate_user!

  def new
    @part = Part.find(params[:part_id])
    @parts = Part.where(user_id: current_user.id)
    @parts_relation = PartsRelation.new();
  end

  def create
  end
end
