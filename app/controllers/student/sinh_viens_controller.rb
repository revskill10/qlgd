#encoding: utf-8
class Student::SinhViensController < TenantsController
	def show
		@sinh_vien = SinhVien.find(params[:sinh_vien_id])
		@lops = @sinh_vien.enrollments.map {|en| en.lop_mon_hoc if en.lop_mon_hoc and !en.lop_mon_hoc.removed? }.select {|l| !l.nil? }.uniq
		
	end
end