class LichTrinhGiangDaySerializer < ActiveModel::Serializer
  attributes :id, :phong, :noi_dung, :state, :sv_co_mat, :sv_vang_mat

  def sv_co_mat
  	0
  end

  def sv_vang_mat
  	0
  end
end