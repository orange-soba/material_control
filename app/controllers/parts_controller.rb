class PartsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_parts, only: [:new, :create]

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

  def show
    @part = Part.find(params[:id])
  end

  def edit
    @part = Part.find(params[:id])
  end

  def update
    @part = Part.find(params[:id])
    if @part.update(part_params)
      redirect_to part_path(@part)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def calculate
    @part = Part.find(params[:id])
    parts_tracer = PartsTracer.new(@part, current_user)

    part_info = parts_tracer.get_part_info
    @parts = part_info[:parts]
    @materials = part_info[:materials]

    order_list = parts_tracer.create_order_list
    @parts_order = order_list[:parts]
    @materials_order = order_list[:materials]
  end
  
  private

  def set_parts
    @parts = Part.where(user_id: current_user.id).order('created_at DESC')
  end

  def part_params
    params.require(:part).permit(:name, :stock, :finished).merge(user_id: current_user.id)
  end
end
