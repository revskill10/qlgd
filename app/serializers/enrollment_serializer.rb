class EnrollmentSerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :name, :code, :status, :so_tiet_vang, :phep, :max

  def status
  	object.status
  end
  def name
  	object.name
  end
  def code
  	object.code
  end
  def max
    object.max
  end
end
