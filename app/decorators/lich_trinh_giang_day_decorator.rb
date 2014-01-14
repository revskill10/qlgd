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
  def content_html
    return '' if content.try(:length) == 0 or content.nil?
    content.gsub(/\n/,'<br/>')
  end
  def updated
  	object.state.to_sym != :nghile and object.state.to_sym != :nghiday and object.accepted? #and object.thoi_gian.localtime <= Time.now
  end
  def sv_co_mat
  	object.lop_mon_hoc.enrollments.count - sv_vang_mat - object.attendances.where("state = 'idle'").count
  end
  
  def sv_vang_mat
  	object.attendances.where("state = 'absent'").count
  end
  
end