class NeedMaterialsController < ApplicationController
  def new
    @part = Part.find(params[:part_id])
  end
end
