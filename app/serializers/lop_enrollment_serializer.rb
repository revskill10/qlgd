class LopEnrollmentSerializer < ActiveModel::Serializer
  self.root = false
  attributes :lop_mon_hoc_id, :sinh_vien_id, :id, :name, :code, :tong_vang


    
  def tong_vang
  	object.tong_vang
  end  
  def name
  	object.sinh_vien.hovaten
  end
  def code
  	object.sinh_vien.code
  end

end