class PartsController < ApplicationController
  before_action :redirect_to_root

  def new
    @part = Part.new
    @parts = Part.where(user_id: current_user.id).order('created_at DESC')
  end

  def create
    @part = Part.new(part_params)
    if @part.valid?
      @part.save
      redirect_to root_path # 本当はマイページ
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  private

  def part_params
    params.require(:part).permit(:name, :stock, :finished).merge(user_id: current_user.id)
  end

  def redirect_to_root
    return if user_signed_in?

    redirect_to root_path
  end
end
