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
    object.started? and object.tong_so_tiet > 0
  end
  def so_tiet_ly_thuyet
  	return 0 if object.pending?
    return 0 unless object.settings
  	object.settings[:so_tiet_ly_thuyet]
  end
  def de_cuong_du_kien
    return '' if object.pending?
    return '' unless object.settings
    object.settings[:de_cuong_du_kien]
  end
  def so_tiet_thuc_hanh
  	return 0 if object.pending?
    return 0 unless object.settings
  	object.settings[:so_tiet_thuc_hanh]
  end
  
end  