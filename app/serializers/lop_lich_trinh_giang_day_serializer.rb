class LopLichTrinhGiangDaySerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :thoi_gian, :tiet_bat_dau, :so_tiet, :phong, :thuc_hanh, :status, :state, :can_remove, :can_restore, :can_edit

  def thoi_gian
    object.thoi_gian.localtime.strftime("%d/%m/%Y")
  end
  
  def thuc_hanh
    return false if object.thuc_hanh.nil?
    return object.thuc_hanh
  end
  
  def can_remove
  	return object.can_remove?
  end

  def can_restore
  	return object.can_restore?
  end

  def can_edit
    object.state == "bosung" and object.status == "waiting"
  end
end