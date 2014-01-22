class CalendarSerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :state, :so_tiet, :giang_vien, :tuan_hoc_bat_dau, :tuan_hoc_ket_thuc, :lop_mon_hoc

  def tuan_hoc_ket_thuc
  	object.tuan_hoc_bat_dau + object.so_tuan
  end
end