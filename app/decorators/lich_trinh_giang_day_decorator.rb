class LichTrinhGiangDayDecorator < Draper::Decorator
  delegate_all
  
  def updated
  	!object.nghile? and !object.nghiday? and !object.removed?
  end
  def sv_co_mat
  	object.attendances.where("state = 'attendant' or state = 'late'").count
  end
  
  def sv_vang_mat
  	object.attendances.where("state = 'absent'").count
  end
end