class Daotao::SinhViensController < TenantsController

	def lop_hanh_chinhs
		svs = SinhVien.where(ma_lop_hanh_chinh: params[:ma_lop_hanh_chinh]).order('position')
		render json: svs.map {|sv| {:id => sv.id, :code => sv.code, :hovaten => sv.hovaten}}, :root => false
	end

	def lop_mon_hocs
		@lop = LopMonHoc.find(params[:lop_id])
		@enrollments = @lop.enrollments.order("enrollments.created_at")
		render json: @enrollments.map {|en| LopEnrollmentSerializer.new(en)}, :root => false
	end

	def show
		sv = SinhVien.find(params[:id])
	end

	def move
		@lop = LopMonHoc.find(params[:lop_id])
		sinh_vien_ids = params[:sinh_viens].map {|k| k and k.to_i}
		@existing_enrollments_ids = @lop.enrollments.where(sinh_vien_id: sinh_vien_ids).map(&:sinh_vien_id)
		(sinh_vien_ids - @existing_enrollments_ids).each do |sinh_vien_id|
			@lop.enrollments.create(sinh_vien_id: sinh_vien_id, bosung: true)
		end
		render json: {:result => "OK"}		
	end

	def remove
		@lop = LopMonHoc.find(params[:lop_id])
		@lop.enrollments.find(params[:enrollment_id]).destroy
		@enrollments = @lop.enrollments.order("enrollments.created_at")
		render json: @enrollments.map {|en| LopEnrollmentSerializer.new(en)}, :root => false
	end
end