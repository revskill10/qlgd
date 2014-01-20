class LichEnrollmentSerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :sinh_vien_id, :dihoc_tinhhinh, :name, :code, :status, :so_tiet_vang, :phep, :max, :phep_status, :note, :tong_vang, :tinhhinh, :idle_status

  def dihoc_tinhhinh
    100 - (tinhhinh || 0)
  end
  def tinhhinh
    object.tinhhinhv
  end
  def tong_vang
    object.tong_vang
  end
  def sinh_vien_id
    object.sinh_vien_id
  end
  def idle_status
    object.idle_status
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
