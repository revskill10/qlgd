class SinhVienSerializer < ActiveModel::Serializer
	self.root = false
	attributes :code, :hovaten, :ma_lop_hanh_chinh

	def hovaten
		object.hovaten
	end
end