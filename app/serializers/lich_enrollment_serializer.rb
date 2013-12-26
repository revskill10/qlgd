class LichEnrollmentSerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :sinh_vien_id, :name, :code, :status, :so_tiet_vang, :phep, :max, :phep_status, :note, :tong_vang

  def tong_vang
    object.tong_vang
  end
  def sinh_vien_id
    object.sinh_vien_id
  end
  def note
    object.note
  end
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
