class LichTrinhGiangDaySerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :phong, :noi_dung, :state, :sv_co_mat, :sv_vang_mat

  def sv_co_mat
  	object.sv_co_mat
  end

  def sv_vang_mat
  	object.sv_vang_mat
  end
  
end