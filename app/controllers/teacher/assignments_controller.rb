#encoding: utf-8
require 'lop_assignment_group_serializer'
class Teacher::AssignmentsController < TenantsController


	
	# get assignments
	def index		
		@lop = LopMonHoc.find(params[:id])
		results = @lop.assignment_groups.map {|g| g and LopMonHocAssignmentGroupSerializer.new(g)}
		render json: results.to_json		
	end
	def create
		@lop = LopMonHoc.find(params[:id])
		authorize @lop, :update?
		@assignment = @lop.assignments.create(assignment_group_id: params[:assignment_group_id], name: params[:name], points: params[:points])
		@assignment.move_to_bottom
		results = @lop.assignment_groups.map {|g| g and LopMonHocAssignmentGroupSerializer.new(g)}
		render json: results.to_json
	end
	
	# update assignment
	def update
		@lop = LopMonHoc.find(params[:id])
		authorize @lop, :update?
		@a = @lop.assignments.find(params[:assignment_id]);
		if @a
			@a.name = params[:name]
			@a.points = params[:points]
			@a.save!
		end
		results = @lop.assignment_groups.map {|g| g and LopMonHocAssignmentGroupSerializer.new(g)}
		render json: results.to_json
	end
	def reorder
		@lop = LopMonHoc.find(params[:id])
		authorize @lop, :update?
		@assignment_group = @lop.assignment_groups.find(params[:assignment_group_id])
		@assignment = @assignment_group.assignments.find(params[:assignment_id])
		@assignment.insert_at(params[:position].to_i + 1);
		results = @lop.assignment_groups.map {|g| g and LopMonHocAssignmentGroupSerializer.new(g)}
		render json: results.to_json		
	end
	# delete assignment
	def delete
		@lop = LopMonHoc.find(params[:id])
		authorize @lop, :update?
		@as = @lop.assignments.find(params[:assignment_id].to_i)
		@as.destroy if @as.can_destroy?
		results = @lop.assignment_groups.map {|g| g and LopMonHocAssignmentGroupSerializer.new(g)}
		render json: results.to_json
	end
end