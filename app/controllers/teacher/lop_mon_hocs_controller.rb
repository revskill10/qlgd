#encoding: utf-8
require 'lop_assignment_group_serializer'
class Teacher::LopMonHocsController < TenantsController

	def index		
		@lop_mon_hocs = policy_scope(LopMonHoc).map{|k| LopMonHocSerializer.new(k)}
		render json: @lop_mon_hocs, :root => false
	end

	def show
		@lop = LopMonHoc.find(params[:id])
		#authorize @lop, :update?
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
		authorize @lop, :update?
		@lop.settings ||= {}	
		@lop.settings[:so_tiet_ly_thuyet] = params[:lt].to_i
    	@lop.settings[:so_tiet_thuc_hanh] = params[:th].to_i
    	@lop.settings[:language] = params[:lang]
    	@lop.settings[:de_cuong_du_kien] = params[:decuong]
    	if !@lop.started?
    		@lop.start!
    	else
    		@lop.save!
    	end

		enrollments = @lop.enrollments    
    	results = enrollments.map {|e| LopEnrollmentSerializer.new(e)}
    	render json: {:lop => LopMonHocSerializer.new(@lop), :enrollments => results}
	end
	

	
end