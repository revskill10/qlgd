require 'lop_assignment_serializer'
class LopMonHocAssignmentGroupSerializer < ActiveModel::Serializer
  self.root = false
  attributes :assignment_group_id, :name, :weight, :assignments

  def assignment_group_id
    object.id
  end

  def assignments
    object.assignments.map {|a| a and LopMonHocAssignmentSerializer.new(a)}
  end
end
