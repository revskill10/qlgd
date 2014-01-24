class Daotao::CalendarSerializer < ActiveModel::Serializer
	self.root = false
  	attributes :id, :tuan_hoc_bat_dau, :so_tuan, :thu, :tiet_bat_dau, :so_tiet, :phong, :can_generate, :can_remove, :can_restore

  	def can_generate
  		object.can_generate?
  	end

  	def can_remove
  		object.can_remove?
  	end

  	def can_restore
  		object.can_restore?
  	end
end