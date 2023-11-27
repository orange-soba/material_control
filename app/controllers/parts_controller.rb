class PartsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_parts, only: [:new, :create, :destroy]
  before_action :set_part, except: [:new, :create]

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
  end

  def edit
  end

  def update
    if @part.update(part_params)
      redirect_to part_path(@part)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def calculate
    parts_tracer = PartsTracer.new(@part, current_user)

    part_info = parts_tracer.get_part_info
    @parts = part_info[:parts]
    @materials = part_info[:materials]

    order_list = parts_tracer.create_order_list
    @parts_order = order_list[:parts]
    @materials_order = order_list[:materials]
  end

  def stock_update
    if @part.update(stock_params)
      redirect_to part_path(@part)
    else
      @errors = @part.errors.full_messages
      render :show, status: :unprocessable_entity
    end
  end

  def destroy
    if @part.destroy
      if params[:now] == 'new'
        redirect_to new_part_path
      else
        redirect_to user_path(current_user)
      end
    else
      @errors = @part.errors.full_messages
      if params[:now] == 'new'
        @part = Part.new
        @part.stock = 0
        render :new, status: :unprocessable_entity
      else
        render :show, status: :unprocessable_entity
      end
    end
  end
  
  private

  def set_part
    @part = Part.find(params[:id])
  end

  def set_parts
    @parts = current_user.parts.order('created_at DESC')
  end

  def part_params
    params.require(:part).permit(:name, :stock, :finished).merge(user_id: current_user.id)
  end

  def stock_params
    params.require(:part).permit(:stock)
  end
end
