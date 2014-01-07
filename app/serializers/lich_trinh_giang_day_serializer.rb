class LichTrinhGiangDaySerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :tuan, :thoi_gian, :phong, :content, :updated, :status, :sv_co_mat, :sv_vang_mat, :so_tiet

  def thoi_gian
    object.thoi_gian.localtime.strftime("%Hh%M %d/%m/%Y")
  end
  def so_tiet
    object.so_tiet
  end
  def content
    object.content
  end
  def updated
  	object.updated
  end
  def sv_co_mat
  	object.sv_co_mat
  end

  def sv_vang_mat
  	object.sv_vang_mat
  end
  
end