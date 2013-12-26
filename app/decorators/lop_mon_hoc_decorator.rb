#encoding: utf-8
class LopMonHocDecorator < Draper::Decorator
  delegate_all

  def language
    return nil if object.pending?
    object.settings["language"]
  end
  def si_so
  	object.enrollments.count
  end
  def updated
    object.started?
  end
  def so_tiet_ly_thuyet
  	return nil if object.pending?
  	object.settings["so_tiet_ly_thuyet"]
  end
  def de_cuong_du_kien
    return nil if object.pending?
    object.settings["de_cuong_du_kien"]
  end
  def so_tiet_thuc_hanh
  	return nil if object.pending?
  	object.settings["so_tiet_thuc_hanh"]
  end
  
end  