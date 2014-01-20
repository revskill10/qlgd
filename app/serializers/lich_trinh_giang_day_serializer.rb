#encoding: utf-8
class LichTrinhGiangDaySerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :can_diem_danh, :color_status, :can_edit, :giang_vien, :tiet_bat_dau, :type_status, :active, :alias_state, :color, :alias_status, :tuan, :thoi_gian, :phong, :content, :content_html, :updated, :status, :sv_co_mat, :sv_vang_mat, :so_tiet, :ma_lop, :ten_mon_hoc, :thu, :ltype, :updated_alias
  DAYS = {0 => 'Chủ nhật', 1 => 'Thứ hai', 2 => 'Thứ ba', 3 => 'Thứ tư', 4 => 'Thứ năm', 5 => 'Thứ sáu', 6 => 'Thứ bảy'}
  def thoi_gian
    object.thoi_gian.localtime.strftime("%Hh%M %d/%m/%Y")
  end
  def thu
    DAYS[object.thoi_gian.localtime.wday]
  end
  def can_edit
    object.can_edit
  end
  def can_diem_danh
    object.can_diem_danh
  end
  def updated_alias
    object.updated_at.localtime.strftime("%Hh%M %d/%m/%Y")
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
  def giang_vien
    object.giang_vien.hovaten
  end    
  def so_tiet
    object.so_tiet
  end
  def active
    object.active?
  end
  def content
    object.content
  end
  def color
    object.color
  end
  def alias_state
    object.alias_state
  end
  def alias_status
    object.alias_status
  end
  def content_html
    return '' if object.content.try(:length) == 0
    object.content.gsub(/\n/,'<br/>')
  end
  def updated
  	object.updated
  end
  def sv_co_mat
  	object.sv_co_mat
  end

  def sv_vang_mat
  	object.sv_vang_mat
  end
  
  def ma_lop
    object.lop_mon_hoc.ma_lop
  end

  def ten_mon_hoc
    object.lop_mon_hoc.ten_mon_hoc
  end
end