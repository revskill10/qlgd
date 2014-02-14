#encoding: utf-8
class SinhVienDecorator < Draper::Decorator
	delegate_all

	def so_lop_mon
		object.enrollments.count
	end
	def so_tiet_vang		
		object.enrollments.inject(0) {|sum,x| sum + x.tong_vang }
	end	
end