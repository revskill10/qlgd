class EnrollmentSerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :name, :code, :status, :so_tiet_vang, :phep, :max, :phep_status

  def phep_status
    object.phep_status
  end
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
