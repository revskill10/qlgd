#encoding: utf-8
class LopMonHocDecorator < Draper::Decorator
  delegate_all

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

  def so_tiet_thuc_hanh
  	return nil if object.pending?
  	object.settings["so_tiet_thuc_hanh"]
  end
  
end  