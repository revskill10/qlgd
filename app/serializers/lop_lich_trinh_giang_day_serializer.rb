#encoding: utf-8
class LopLichTrinhGiangDaySerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :tuan, :thoi_gian, :tiet_bat_dau, :so_tiet, :phong, :thuc_hanh, :alias_status, :alias_state, :can_remove, :can_restore, :can_edit, :can_nghiday, :can_accept, :can_unnghiday, :can_uncomplete

  def thoi_gian
    object.thoi_gian.localtime.strftime("%d/%m/%Y")
  end
  
  def thuc_hanh
    return false if object.thuc_hanh.nil?
    return object.thuc_hanh
  end
  
  def alias_state
    object.alias_state
  end
  def alias_status
    object.alias_status
  end
  def can_remove
  	object.can_remove?
  end

  def can_restore
  	object.can_restore?
  end

  def can_edit
    object.can_edit?
  end

  def can_nghiday
    object.can_nghiday?
  end

  def can_accept
    object.can_giang_vien_accept?
  end

  def can_unnghiday
    object.can_unnghiday?
  end

  def can_uncomplete
    object.can_uncomplete?
  end
end