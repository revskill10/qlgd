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
		@lop.update_attributes(params[:lop])
		enrollments = @lop.enrollments    
    	results = enrollments.map {|e| LopEnrollmentSerializer.new(e)}
    	render json: {:lop => LopMonHocSerializer.new(@lop), :enrollments => results}
	end
end