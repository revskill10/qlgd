#encoding: utf-8
require 'lop_assignment_group_serializer'
class LopMonHocsController < ApplicationController
	def index
		if guest?        
			
		elsif teacher?        
			@giang_vien = current_user.imageable
			@lops = @giang_vien.lop_mon_hocs.map{|k| LopMonHocSerializer.new(k)}
			render json: @lops, :root => false
		elsif student?        
			
		end
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
		@gv = @lop.giang_viens.find(params[:giang_vien])	
		@lop.settings ||= {}	
		@lop.settings[:so_tiet_ly_thuyet] = params[:lt].to_i
    	@lop.settings[:so_tiet_thuc_hanh] = params[:th].to_i
    	@lop.settings[:language] = params[:lang]
    	@lop.settings[:de_cuong_du_kien] = params[:decuong]
    	if !@lop.started?
    		@lop.start!(@gv)
    	else
    		@lop.save!
    	end

		enrollments = @lop.enrollments    
    	results = enrollments.map {|e| LopEnrollmentSerializer.new(e)}
    	render json: {:lop => LopMonHocSerializer.new(@lop), :enrollments => results}
	end
	

	
end