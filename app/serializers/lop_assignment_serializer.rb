class LopMonHocAssignmentSerializer < ActiveModel::Serializer
  self.root = false
  attributes :assignment_id, :name, :points, :description

  def assignment_id
    object.id
  end

end
