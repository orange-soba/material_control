class NeedMaterialsController < ApplicationController
  def new
    @part = Part.find(params[:part_id])
    @need_material = NeedMaterial.new
    @materials = Material.where(user_id: current_user.id)
  end

  def create
    binding.pry
  end
end
