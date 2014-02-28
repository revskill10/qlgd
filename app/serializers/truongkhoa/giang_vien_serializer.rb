class Truongkhoa::GiangVienSerializer < ActiveModel::Serializer
  self.root = false
  attributes :giang_vien_id, :ten_giang_vien, :data
  def giang_vien_id
  	object.id
  end
  def ten_giang_vien
  	object.hovaten
  end
  def data
  	object.lop_mon_hocs.map {|lop| Truongkhoa::LopMonHocSerializer.new(lop)}
  end
end