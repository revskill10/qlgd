class LichTrinhGiangDayDecorator < Draper::Decorator
  delegate_all
  

  def so_tiet
    object.so_tiet_moi
  end
  def phong
    return '' unless object.phong
    return object.phong
  end
  def content
    return "" unless object.noi_dung
    object.noi_dung
  end
  def updated
  	object.state != :nghile and object.state != :nghiday and object.accepted?
  end
  def sv_co_mat
  	object.lop_mon_hoc.enrollments.count - sv_vang_mat - object.attendances.where("state = 'idle'").count
  end
  
  def sv_vang_mat
  	object.attendances.where("state = 'absent'").count
  end
  def alias_state
    object.alias_state
  end
  def alias_status
    object.alias_status
  end
end