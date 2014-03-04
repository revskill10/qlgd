#encoding: utf-8
class Truongkhoa::LichTrinhGiangDaysSerializer < ActiveModel::Serializer
	self.root = false
	attributes :id, :thoi_gian, :noi_dung, :alias_thoi_gian, :tuan, :so_tiet, :so_tiet_moi, :alias_state, :alias_status, :type_status

	def alias_thoi_gian
		object.thoi_gian.localtime.strftime("%H:%M %d/%m/%Y")
	end

	def alias_state
		object.alias_state
	end

	def alias_status
		object.alias_status
	end

	def type_status
		object.type_status
	end

end