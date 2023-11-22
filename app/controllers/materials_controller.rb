class MaterialsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_data, except: [:edit, :update]

  def index
  end

  def new
    @material = Material.new
    @material.stock = 0.0
  end

  def create
    material = Material.new(material_params)
    if material.valid?
      material.save
      current_user.increment!(:registered_material_nums)
      
      render json: { success: true, material: material }
    else
      render json: { success: false, material: material, errors: material.errors.full_messages }
    end
  end

  def edit
    @material = Material.find(params[:id])
  end

  def update
    @material = Material.find(params[:id])
    if @material.update(update_params)
      redirect_to materials_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    material = Material.find(params[:id])
    if material.destroy
      if params[:now] == "new"
        redirect_to new_material_path
      else
        redirect_to materials_path
      end
    else
      @errors = material.errors.full_messages
      if params[:now] == "new"
        @material = Material.new
        @material.stock = 0.0
        render :new, status: :unprocessable_entity
      else
        render :index, status: :unprocessable_entity
      end
    end
  end

  def stock_update
    material = Material.find(params[:id])
    if material.update(stock_params)
      redirect_to materials_path
    else
      @errors = material.errors.full_messages
      render :index, status: :unprocessable_entity
    end
  end

  private

  def material_params
    len = current_user.registered_material_nums
    params.require(:material).permit(permit_attributes).merge(material_id: len + 1, user_id: current_user.id)
  end

  def stock_params
    params.require(:material).permit(:stock)
  end

  def update_params
    params.require(:material).permit(permit_attributes)
  end

  def permit_attributes
    [:material_type, :category, :thickness, :width, :option, :length, :stock]
  end

  def set_data
    @materials = Material.where(user_id: current_user.id).order('created_at DESC')
  end
end
