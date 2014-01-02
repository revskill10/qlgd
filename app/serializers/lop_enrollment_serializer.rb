class LopEnrollmentSerializer < ActiveModel::Serializer
  self.root = false
  attributes :lop_mon_hoc_id, :sinh_vien_id, :id, :name, :code, :tong_vang, :diem_chuyen_can, :tinhhinh, :dihoc_tinhhinh


    
  def tong_vang
  	object.tong_vang
  end  
  def name
  	object.sinh_vien.hovaten
  end
  def code
  	object.sinh_vien.code
  end
  def tinhhinh
    return 0 if (tong_so_tiet == 0)
    (tong_vang * 100.0 / tong_so_tiet).round(2)
  end
  def dihoc_tinhhinh
    return (100 - tinhhinh).round(2)
  end
  def diem_chuyen_can
    return nil unless object.lop_mon_hoc.started?
    case percent
    when 100
      4
    when 90..99
      3
    when 80..89
      2
    when 70..79
      1
    else
      0
    end
  end
  private
  def tong_vang
    @tong_vang ||= object.tong_vang
    @tong_vang
  end
  def tong_so_tiet
    return 1 if object.lop_mon_hoc.tong_so_tiet == 0
    @tong_so_tiet ||= object.lop_mon_hoc.tong_so_tiet
    @tong_so_tiet
  end
  def percent    
    sv = (tong_so_tiet - tong_vang) / tong_so_tiet.to_f
    (sv * 100 ).round(2).to_i
  end
end