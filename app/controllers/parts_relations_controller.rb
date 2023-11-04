class PartsRelationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_data

  def new
    @parts_relation = PartsRelation.new();
  end

  def create
    @parts_relation = PartsRelation.new(relation_params)
    if @parts_relation.valid?
      @parts_relation.save
      redirect_to new_part_parts_relations_path(@part.id)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_data
    @part = Part.find(params[:part_id])
    @parts = Part.where(user_id: current_user.id).where.not(id: params[:part_id])
  end

  def relation_params
    params.require(:parts_relation).permit(:child_id, :necessary_nums).merge(parent_id: @part.id)
  end
  # def relation_params
  #   child = Part.find(params[:parts_relation][:child])
  #   params.require(:parts_relation).permit(:child, :necessary_nums).merge(parent_id: @part.id, child: child)
  # end
  
end
