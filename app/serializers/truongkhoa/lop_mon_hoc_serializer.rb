#encoding: utf-8
class Truongkhoa::LopMonHocSerializer < ActiveModel::Serializer
  self.root = false
  attributes :lop_mon_hoc_id, :ma_lop, :ten_mon_hoc, :duyet_thong_so, :duyet_lich_trinh, :duyet_tinh_hinh, :duyet_thong_so_status, :duyet_lich_trinh_status, :duyet_tinh_hinh_status, :can_approve_thong_so, :can_reject_thong_so, :can_approve_lich_trinh, :can_reject_lich_trinh, :can_approve_tinh_hinh, :can_reject_tinh_hinh, :giang_viens, :de_cuong_chi_tiet_html

  def lop_mon_hoc_id
    object.id
  end
  def can_approve_thong_so
    !duyet_thong_so
  end
  def can_reject_thong_so
    duyet_thong_so
  end
  def can_approve_lich_trinh
    !duyet_lich_trinh
  end
  def can_reject_lich_trinh
    duyet_lich_trinh
  end
  def can_approve_tinh_hinh
    !duyet_tinh_hinh
  end
  def can_reject_tinh_hinh
    duyet_tinh_hinh
  end
  def duyet_thong_so
    return true if object.duyet_thong_so == true
    return false
  end
  def duyet_thong_so_status
    return "Đã duyệt" if duyet_thong_so
    return "Chưa duyệt"
  end
  def duyet_lich_trinh
    return true if object.duyet_lich_trinh == true
    return false
  end
  def duyet_lich_trinh_status
    return "Đã duyệt" if duyet_lich_trinh
    return "Chưa duyệt"
  end
  def duyet_tinh_hinh
    return true if object.duyet_tinh_hinh == true
    return false
  end
  def duyet_tinh_hinh_status
    return "Đã duyệt" if duyet_tinh_hinh
    return "Chưa duyệt"
  end
  def giang_viens
    object.giang_viens.map {|t| t.hovaten}.join(", ")
  end
  def de_cuong_chi_tiet_html
    return '' unless object.settings[:de_cuong_chi_tiet]
    return '' if object.settings[:de_cuong_chi_tiet].try(:length) == 0
    object.settings[:de_cuong_chi_tiet].gsub(/\n/,'<br/>')
  end
end