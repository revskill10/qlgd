#encoding: utf-8
class SinhVienDecorator < Draper::Decorator
	delegate_all

	def so_lop_mon
		object.enrollments.count
	end	
end