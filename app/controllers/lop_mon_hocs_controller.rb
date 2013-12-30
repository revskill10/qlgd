#encoding: utf-8
require 'lop_assignment_group_serializer'
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
		@lop.settings ||= {}	
		@lop.settings["so_tiet_ly_thuyet"] = params[:lt].to_i
    	@lop.settings["so_tiet_thuc_hanh"] = params[:th].to_i
    	@lop.settings["language"] = params[:lang]
    	@lop.settings["de_cuong_du_kien"] = params[:decuong]
    	@lop.start!
		enrollments = @lop.enrollments    
    	results = enrollments.map {|e| LopEnrollmentSerializer.new(e)}
    	render json: {:lop => LopMonHocSerializer.new(@lop), :enrollments => results}
	end
	# get assignments
	def assignments		
		@lop = LopMonHoc.find(params[:id])
		results = @lop.assignment_groups.map {|g| g and LopMonHocAssignmentGroupSerializer.new(g)}
		render json: results.to_json
	end
	def create_assignment
		@lop = LopMonHoc.find(params[:id])
		@lop.assignments.create(assignment_group_id: params[:assignment_group_id], giang_vien_id: params[:giang_vien_id], name: params[:name], points: params[:points])
		results = @lop.assignment_groups.map {|g| g and LopMonHocAssignmentGroupSerializer.new(g)}
		render json: results.to_json
	end
	# post
	def create_assignment_group
		@lop = LopMonHoc.find(params[:id])
		@lop.assignment_groups.create(giang_vien_id: params[:giang_vien_id], name: params[:name], weight: params[:weight])
		results = @lop.assignment_groups.map {|g| g and LopMonHocAssignmentGroupSerializer.new(g)}
		render json: results.to_json
	end
	# update assignment
	def update_assignment
		@lop = LopMonHoc.find(params[:id])
		@a = @lop.assignments.find(params[:assignment_id]);
		if @a
			@a.name = params[:name]
			@a.points = params[:points]
			@a.save!
		end
		results = @lop.assignment_groups.map {|g| g and LopMonHocAssignmentGroupSerializer.new(g)}
		render json: results.to_json
	end
	# delete assignment group
	def delete_assignment_group
		@lop = LopMonHoc.find(params[:id])
		@as = @lop.assignment_groups.find(params[:assignment_group_id]);
		@as.destroy if @as
		results = @lop.assignment_groups.map {|g| g and LopMonHocAssignmentGroupSerializer.new(g)}
		render json: results.to_json
	end
	# update assignment group
	def update_assignment_group
		@lop = LopMonHoc.find(params[:id])
		@as = @lop.assignment_groups.find(params[:assignment_group_id]);
		if @as
			@as.name = params[:name]
			@as.weight = params[:weight]
			@as.save!
		end
		results = @lop.assignment_groups.map {|g| g and LopMonHocAssignmentGroupSerializer.new(g)}
		render json: results.to_json
	end
	# delete assignment
	def delete_assignment
		@lop = LopMonHoc.find(params[:id])
		@a = @lop.assignments.find(params[:assignment_id]);
		@a.destroy if @a
		results = @lop.assignment_groups.map {|g| g and LopMonHocAssignmentGroupSerializer.new(g)}
		render json: results.to_json
	end

	# get grades
	def submissions
		@lop = LopMonHoc.find(params[:id])
		assignments = @lop.assignments
		count = 0
		names = [{:name => "Họ và tên"}]
		names += assignments.map {|a| {:name => a.name, :points => a.points, :group_name => a.assignment_group.name, :group_weight => a.assignment_group.weight}}
		enrollments = @lop.enrollments
		results = enrollments.map do |en|
			tmp = {:name => en.sinh_vien.hovaten, :assignments => []}			
			assignments.each_with_index do |as, index|				
				tmp[:assignments] << EnrollmentSubmissionSerializer.new(EnrollmentSubmissionDecorator.new(en, as, index + count))
			end
			count += assignments.count
			tmp
		end
	    
	    render json: {:names => names, :results => results}.to_json		
	end

end