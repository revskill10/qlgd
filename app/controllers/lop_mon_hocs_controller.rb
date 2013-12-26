class LopMonHocsController < ApplicationController
	def show
		@lop = LopMonHoc.find(params[:id])
		enrollments = @lop.enrollments    
    	results = enrollments.map {|e| LopEnrollmentSerializer.new(e)}
    	render json: {:lop => LopMonHocSerializer.new(@lop), :enrollments => results}
	end
	def info
		@lop = LopMonHoc.find(params[:lop_id])
		render json: LopMonHocSerializer.new(@lop)
	end
	def update
		@lop = LopMonHoc.find(params[:id])		
		@lop.settings["so_tiet_ly_thuyet"] = params[:lt].to_i
    	@lop.settings["so_tiet_thuc_hanh"] = params[:th].to_i
    	@lop.settings["language"] = params[:lang]
    	@lop.settings["de_cuong_du_kien"] = params[:decuong]
    	@lop.start!
		enrollments = @lop.enrollments    
    	results = enrollments.map {|e| LopEnrollmentSerializer.new(e)}
    	render json: {:lop => LopMonHocSerializer.new(@lop), :enrollments => results}
	end
end