class PartsTracer
  attr_reader :part, :part_info

  def initialize(part, user)
    @part = part
    @part_info = {parts: [], materials: {}}
    @user = user
  end

  def get_part_info
    self.class.get_parts_materials(@part, @part_info, @user)

    @part_info
  end

  def self.trace_descendants_arr(child_id, descendants = [])
    child = Part.find(child_id)
    descendants << child

    child.children.each do |grand_child|
      trace_descendants_arr(grand_child.id, descendants)
    end
  end

  def self.trace_ancestors_arr(parent_id, ancestors = [])
    parent = Part.find(parent_id)
    ancestors << parent

    parent.parents.each do |grand_parent|
      trace_ancestors_arr(grand_parent.id, ancestors)
    end
  end

  private

  def self.get_parts_materials(part, part_info = {parts: [], materials: {}}, user)
    if !part.need_materials.empty?
      get_materials(part, part_info, user)
    end

    part.children.each do |child|
      if child.children.empty? && child.need_materials.empty?
        part_info[:parts] << child
        next
      end

      child.children.each do |grand_child|
        get_parts_materials(child, part_info, user)
      end
    end
  end

  def self.get_materials(part, part_info = {parts: [], materials: {}}, user)
    part.need_materials.each do |need_material|
      material = Material.find_by(material_id: need_material[:material_id], user_id: user.id)
      length = need_material.length
      nums = need_material.necessary_nums
      
      part_info[:materials][material.id] ||= {}
      part_info[:materials][material.id][length] ||= 0
      part_info[:materials][material.id][length] += nums
    end
  end
end

# 例)
# part_info - parts = []
#           - materials = { material_id: { length: nums }
#                           }
# part_info - parts = [モーター、減速機]
#           - materials = { 1: { 130: 3 , 100: 2},
#                           3: { 200: 1}
#                          }