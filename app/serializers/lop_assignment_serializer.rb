class LopMonHocAssignmentSerializer < ActiveModel::Serializer
  self.root = false
  attributes :assignment_id, :name, :points, :description, :can_destroy

  def assignment_id
    object.id
  end
  def can_destroy
  	object.can_destroy?
  end
end
