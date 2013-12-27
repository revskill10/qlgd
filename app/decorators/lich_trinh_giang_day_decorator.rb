class LichTrinhGiangDayDecorator < Draper::Decorator
  delegate_all
  
  def content
    return nil unless object.noi_dung
    object.noi_dung
  end
  def updated
  	object.state != :nghile and object.state != :nghiday
  end
  def sv_co_mat
  	object.attendances.where("state = 'attendant' or state = 'late'").count
  end
  
  def sv_vang_mat
  	object.attendances.where("state = 'absent'").count
  end
end