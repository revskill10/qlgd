#encoding: utf-8
class Daotao::LichTrinhGiangDaySerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :color_status, :tiet_bat_dau, :type_status, :alias_state, :color, :alias_status, :tuan, :thoi_gian, :phong, :status, :so_tiet, :ma_lop, :ten_mon_hoc, :thu, :ltype, :giang_vien
  DAYS = {0 => 'Chủ nhật', 1 => 'Thứ hai', 2 => 'Thứ ba', 3 => 'Thứ tư', 4 => 'Thứ năm', 5 => 'Thứ sáu', 6 => 'Thứ bảy'}
  def thoi_gian
    object.thoi_gian.localtime.strftime("%Hh%M %d/%m/%Y")
  end
  def thu
    DAYS[object.thoi_gian.localtime.wday]
  end    
  def giang_vien
    object.giang_vien.hovaten
  end
  def color_status
    object.color_status
  end
  def ltype
    object.ltype
  end
  def type_status
    object.type_status
  end  
  def so_tiet
    object.so_tiet
  end  
  def ma_lop
    object.lop_mon_hoc.ma_lop
  end
  def ten_mon_hoc
    object.lop_mon_hoc.ten_mon_hoc
  end
end