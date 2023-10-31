class PartsController < ApplicationController
  before_action :redirect_to_root
  before_action :set_parts

  def new
    @part = Part.new
    @part.stock = 0 # デフォルトで「0」を入力
  end

  def create
    @part = Part.new(part_params)
    if @part.valid?
      @part.save
      redirect_to root_path # 本当はマイページ(or Javascriptで遷移しない)
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  private

  def set_parts
    @parts = Part.where(user_id: current_user.id).order('created_at DESC')
  end

  def part_params
    params.require(:part).permit(:name, :stock, :finished).merge(user_id: current_user.id)
  end

  def redirect_to_root
    return if user_signed_in?

    redirect_to root_path
  end
end
