class PartsTracer
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
end