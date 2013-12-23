class EnrollmentSerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :name, :code, :status

  def status
  	object.status
  end
  def name
  	object.name
  end
  def code
  	object.code
  end
end
