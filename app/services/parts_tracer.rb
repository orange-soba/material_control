class PartsTracer
  attr_reader :part, :part_info

  def initialize(part, user)
    @part = part
    @part_info = { parts: {}, materials: {} }
    @user = user
  end

  def get_part_info
    get_parts_materials(@part)

    @part_info
  end

  def create_order_list
    order_parts = []
    order_pdfs = {}
    @part_info[:parts].each do |part_id, necessary_nums|
      part = Part.find(part_id)
      if part.stock < necessary_nums
        order_parts << [part.name, necessary_nums - part.stock]
        order_pdfs[part.order_destination] ||= []
        order_pdfs[part.order_destination] << [part.name, necessary_nums - part.stock]
      end
    end
  
    order_materials = []
    # cutting_allow = @user.cutting_allow # 切り代(usersデータベースにカラム追加及び編集機能実装後実装)
    @part_info[:materials].each do |material_id, material_hash|
      material =  Material.find_by(material_id: material_id, user_id: @user.id)
      stock_length = material.stock * material.length
  
      length_sum = 0
      material_hash.each do |length, nums|
        length_sum += (length + 5) * nums 
        # length_sum += (length + cutting_allow) * nums
      end
  
      if stock_length < length_sum
        order_nums = ((length_sum - stock_length) / material.length).ceil
        order_materials << [material.display_combine, order_nums]
        order_pdfs[material.order_destination] ||= []
        order_pdfs[material.order_destination] << [material.display_combine, order_nums]
      end
    end
  
    order_list = {}
    order_list[:parts] = order_parts
    order_list[:materials] = order_materials
    order_list[:pdf] = order_pdfs
  
    order_list
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

  def get_parts_materials(part, coefficient = 1)
    if part.need_materials.exists?
      get_materials(part, coefficient)
    end

    part.children.each do |child|
      parts_relation = PartsRelation.find_by(parent_id: part.id, child_id: child.id)
      necessary_nums = parts_relation.necessary_nums * coefficient

      if !child.children.exists? && !child.need_materials.exists?
        @part_info[:parts][child.id] ||= 0
        @part_info[:parts][child.id] += necessary_nums
        
        next
      end

      get_parts_materials(child, necessary_nums)
    end
  end

  def get_materials(part, coefficient = 1)
    part.need_materials.each do |need_material|
      material = Material.find_by(material_id: need_material[:material_id], user_id: @user.id)
      length = need_material.length
      nums = need_material.necessary_nums
      
      @part_info[:materials][material.material_id] ||= {}
      @part_info[:materials][material.material_id][length] ||= 0
      @part_info[:materials][material.material_id][length] += nums * coefficient
    end
  end
end

# 例)
# part_info - parts = { part: nums }
#           - materials = { material_id: { length: nums }
#                           }
# part_info - parts = [[モーター, 2]、[減速機, 1]]
#           - materials = { 1: { 130: 3 , 100: 2},
#                           3: { 200: 1}
#                          }