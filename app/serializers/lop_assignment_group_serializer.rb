require 'lop_assignment_serializer'
class LopMonHocAssignmentGroupSerializer < ActiveModel::Serializer
  self.root = false
  attributes :assignment_group_id, :name, :weight, :assignments, :can_destroy

  def assignment_group_id
    object.id
  end

  def assignments
    object.assignments.map {|a| a and LopMonHocAssignmentSerializer.new(a)}
  end  
  def can_destroy
  	object.can_destroy?
  end
end
