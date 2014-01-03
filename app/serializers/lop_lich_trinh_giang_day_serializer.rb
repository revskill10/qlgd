class LopLichTrinhGiangDaySerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :thoi_gian, :tiet_bat_dau, :so_tiet, :phong, :thuc_hanh, :status

  def thoi_gian
    object.thoi_gian.localtime.strftime("%d/%m/%Y")
  end
  
  def thuc_hanh
    return false if object.thuc_hanh.nil?
    return object.thuc_hanh
  end
  
end