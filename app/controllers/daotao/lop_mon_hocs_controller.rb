class Daotao::LopMonHocsController < TenantsController
	def index
		 #raise "not authorized" unless LopMonHocPolicy.new(current_user, LopMonHoc).daotao?		
		@lops = LopMonHoc.all
		render json: {count: @lops.count, lops: @lops}
	end
	def create
		raise "not authorized" unless LopMonHocPolicy.new(current_user, LopMonHoc).daotao?		
	end
	def delete
		raise "not authorized" unless LopMonHocPolicy.new(current_user, LopMonHoc).daotao?		
		@lop = LopMonHoc.find(params[:lop_id])
		authorize @lop, :daotao
		@lop.destroy!
		render json: {:result => "OK"}
	end
end