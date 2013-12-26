class LopMonHocSerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :ma_lop, :ma_mon_hoc, :ten_mon_hoc, :si_so, :so_tiet_ly_thuyet, :so_tiet_thuc_hanh, :updated, :de_cuong_du_kien, :language

  def language
    object.decorate.language
  end
  def de_cuong_du_kien
    object.decorate.de_cuong_du_kien
  end
  def updated
    object.decorate.updated
  end
  def si_so
  	object.decorate.si_so
  end

  def so_tiet_ly_thuyet
  	object.decorate.so_tiet_ly_thuyet
  end

  def so_tiet_thuc_hanh
  	object.decorate.so_tiet_thuc_hanh
  end
end