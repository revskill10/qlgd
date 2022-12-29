class LopMonHocSerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :khoi_luong_du_kien, :khoi_luong_thuc_hien, :ma_lop, :ma_mon_hoc, :ten_mon_hoc, :si_so, :so_tiet_ly_thuyet, :so_tiet_thuc_hanh, :updated, :lich_trinh_du_kien, :lich_trinh_du_kien_html, :language, :de_cuong_chi_tiet, :de_cuong_chi_tiet_html, :so_tiet_tu_hoc, :so_tiet_bai_tap

  def language
    object.decorate.language
  end
  def lich_trinh_du_kien_html
    return '' if object.decorate.lich_trinh_du_kien.try(:length) == 0 or object.decorate.lich_trinh_du_kien.nil?
    object.decorate.lich_trinh_du_kien.gsub(/\n/,'<br/>')
  end
  def lich_trinh_du_kien
    return '' if object.decorate.lich_trinh_du_kien.try(:length) == 0
    object.decorate.lich_trinh_du_kien
  end
  def de_cuong_chi_tiet_html
    return '' if object.decorate.de_cuong_chi_tiet.try(:length) == 0 or object.decorate.de_cuong_chi_tiet.nil?
    object.decorate.de_cuong_chi_tiet.gsub(/\n/,'<br/>')
  end
  def de_cuong_chi_tiet
    return '' if object.decorate.de_cuong_chi_tiet.try(:length) == 0
    object.decorate.de_cuong_chi_tiet
  end
  def khoi_luong_du_kien
    #so_tiet_ly_thuyet + so_tiet_thuc_hanh
    object.khoi_luong_du_kien
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

  def so_tiet_tu_hoc
    object.decorate.so_tiet_tu_hoc
  end

  def so_tiet_bai_tap
    object.decorate.so_tiet_bai_tap
  end
end