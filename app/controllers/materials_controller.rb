class MaterialsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_data

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

  private

  def material_params
    len = current_user.registered_material_nums
    permit_array = [:material_type, :category, :thickness, :width, :option, :length, :stock]
    params.require(:material).permit(permit_array).merge(material_id: len + 1, user_id: current_user.id)
  end

  def set_data
    @materials = Material.where(user_id: current_user.id).order('created_at DESC')
  end
end
