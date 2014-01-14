#encoding: utf-8
class LopMonHocDecorator < Draper::Decorator
  delegate_all

  def language
    return '' if object.pending?
    return '' unless object.settings
    object.settings[:language]
  end
  def si_so
  	object.enrollments.count
  end
  def updated
    object.started? # and object.tong_so_tiet > 0
  end
  def so_tiet_ly_thuyet
  	return 0 if object.pending?
    return 0 unless object.settings
  	object.settings[:so_tiet_ly_thuyet]
  end
  def lich_trinh_du_kien
    return '' if object.pending?
    return '' unless object.settings
    object.settings[:lich_trinh_du_kien]
  end
  def de_cuong_chi_tiet
    return '' if object.pending?
    return '' unless object.settings
    object.settings[:de_cuong_chi_tiet]
  end
  def de_cuong_chi_tiet_html
    return '' if de_cuong_chi_tiet.try(:length) == 0 or de_cuong_chi_tiet.nil?
    de_cuong_chi_tiet.gsub(/\n/,'<br/>')
  end
  def so_tiet_thuc_hanh
  	return 0 if object.pending?
    return 0 unless object.settings
  	object.settings[:so_tiet_thuc_hanh]
  end
  def so_tiet_tu_hoc
    return 0 if object.pending?
    return 0 unless object.settings
    object.settings[:so_tiet_tu_hoc]
  end
  def so_tiet_bai_tap
    return 0 if object.pending?
    return 0 unless object.settings
    object.settings[:so_tiet_bai_tap]
  end
end  