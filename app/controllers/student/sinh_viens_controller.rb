#encoding: utf-8
class Student::SinhViensController < TenantsController
	def show
		@sinh_vien = SinhVien.find(params[:sinh_vien_id])	
		@enrollments = @sinh_vien.enrollments.includes(:lop_mon_hoc).select {|en| !en.lop_mon_hoc.nil?}	
		@lops = @enrollments.map {|en| en.lop_mon_hoc if en.lop_mon_hoc and !en.lop_mon_hoc.removed? }.select {|l| !l.nil? }.uniq
		@lichs = @lops.inject([]) {|res, elem| res + elem.lich_trinh_giang_days}.sort_by {|l| [l.thoi_gian, l.phong]}
		respond_to do |html|
			format.html {render "dashboard/student/show"}
		end		
	end
end