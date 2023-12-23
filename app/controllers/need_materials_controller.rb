class NeedMaterialsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_data

  def new
    @need_material = NeedMaterial.new
  end

  def create
    @need_material = NeedMaterial.new(need_material_params)
    if @need_material.valid?
      @need_material.save

      redirect_to new_part_need_materials_path(@part)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    need_material = NeedMaterial.find_by(part_id: params[:part_id], material_id: params[:material_id])
    if need_material.destroy
      redirect_to part_path(params[:part_id])
    else
      flash[:errors_need_material_destroy] = need_material.errors.full_messages

      redirect_to part_path(params[:part_id])
    end
  end

  private

  def set_data
    @part = Part.find(params[:part_id])
    @materials = Material.where(user_id: current_user.id)
    @need_materials = NeedMaterial.where(user_id: current_user.id).order('created_at DESC')
  end
  
  def need_material_params
    params.require(:need_material).permit(:material_id, :length, :length_option, :necessary_nums)
                                  .merge(part_id: params[:part_id], user_id: current_user.id)
  end
end
