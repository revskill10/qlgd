class LichTrinhGiangDaySerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :phong, :content, :updated, :status, :sv_co_mat, :sv_vang_mat

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