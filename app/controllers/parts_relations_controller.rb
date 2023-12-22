class PartsRelationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_data, except: :destroy

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

  def destroy
    parts_relation = current_user.parts_relations.find_by(parent_id: params[:part_id], child_id: params[:child_id])
    if parts_relation.destroy
      redirect_to part_path(params[:part_id])
    else
      flash[:errors_parts] = parts_relation.errors.full_messages

      redirect_to part_path(params[:part_id])
    end
  end

  def update
    parts_relation = current_user.parts_relations.find_by(parent_id: params[:part_id], child_id: params[:child_id])
    if parts_relation.update(relation_params)
      redirect_to part_path(params[:part_id])
    else
      flash[:errors_parts_relation_update] = parts_relation.errors.full_messages

      redirect_to part_path(params[:part_id])
    end
  end

  private

  def set_data
    @part = Part.find(params[:part_id])
    @parts = Part.where(user_id: current_user.id).where.not(id: params[:part_id])
    @parts_relations = PartsRelation.where(user_id: current_user.id).order('created_at DESC')
  end

  def relation_params
    params.require(:parts_relation).permit(:child_id, :necessary_nums).merge(parent_id: @part.id, user_id: current_user.id)
  end
end
