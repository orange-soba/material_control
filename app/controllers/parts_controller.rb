class PartsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_parts

  def new
    @part = Part.new
    @part.stock = 0 # デフォルトで「0」を入力
  end

  def create
    part = Part.new(part_params)
    if part.valid?
      part.save
      render json: { success: true, part: part }
    else
      part.stock ||= 0
      render json: { success: false, part: part, errors: part.errors.full_messages }
    end
  end
  
  private

  def set_parts
    @parts = Part.where(user_id: current_user.id).order('created_at DESC')
  end

  def part_params
    params.require(:part).permit(:name, :stock, :finished).merge(user_id: current_user.id)
  end
end
